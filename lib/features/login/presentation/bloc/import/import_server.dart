import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bahasa/core/constants/server_routes.dart';
import 'package:bahasa/core/errors/import_error.dart';
import 'package:bahasa/core/utils/random_char.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

/// Events emitted by [ImportServer] while it runs.
/// A Bloc (or anything else) subscribes to [ImportServer.events]
/// to track status without touching the server internals.
sealed class ImportServerEvent {}

class ImportServerListening extends ImportServerEvent {
  final String ipHost;
  ImportServerListening(this.ipHost);
}

class ImportServerReceiving extends ImportServerEvent {
  final String? ipOrigin;
  final String fileName;
  final int? fileSize;
  final int progress;
  ImportServerReceiving({
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
    required this.progress,
  });
}

class ImportServerComplete extends ImportServerEvent {
  final String filePath;
  ImportServerComplete(this.filePath);
}

class ImportServerCancelled extends ImportServerEvent {}

class ImportServerError extends ImportServerEvent {
  final Exception error;
  ImportServerError(this.error);
}

/// Owns the Shelf HTTP server used for the local Wi-Fi file-transfer flow.
/// Pure infrastructure — no Bloc/state imports here.
class ImportServer {
  HttpServer? _server;
  final _controller = StreamController<ImportServerEvent>.broadcast();

  // Track the in-flight transfer so cancel() can reach into it.
  StreamSubscription<List<int>>? _activeSub;
  IOSink? _activeSink;
  String? _activeTempPath;
  bool _cancelRequested = false;

  Stream<ImportServerEvent> get events => _controller.stream;
  bool get isRunning => _server != null;
  bool get isReceiving => _activeSub != null;

  Router _createHandler() {
    final handler = Router();
    handler.get(checkPath, (Request request) => Response.ok("OK"));
    handler.post(receivePath, _receive);
    return handler;
  }

  Future<void> start() async {
    await stop();

    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    if (ip == null) {
      final error = NoHostIp();
      _controller.add(ImportServerError(error));
      throw error;
    }

    final handler = _createHandler();
    _server = await io.serve(handler.call, '0.0.0.0', 7000);
    _controller.add(ImportServerListening(ip));
  }

  Future<void> restart() => start();

  Future<void> stop() async {
    await _cleanupActiveTransfer(deleteFile: false);
    await _server?.close();
    _server = null;
  }

  /// Cancel the transfer currently in progress, if any. No-op if idle.
  Future<void> cancel() async {
    if (_activeSub == null) return;
    _cancelRequested = true;
    await _cleanupActiveTransfer(deleteFile: true);
    _controller.add(ImportServerCancelled());
  }

  Future<void> _cleanupActiveTransfer({required bool deleteFile}) async {
    await _activeSub?.cancel();
    _activeSub = null;

    try {
      await _activeSink?.flush();
    } catch (_) {}
    try {
      await _activeSink?.close();
    } catch (_) {}
    _activeSink = null;

    if (deleteFile && _activeTempPath != null) {
      final f = File(_activeTempPath!);
      if (await f.exists()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
    _activeTempPath = null;
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }

  Future<Response> _receive(Request request) async {
    final formDataRequest = request.formData();
    if (formDataRequest == null) {
      final error = ImportNotValid();
      _controller.add(ImportServerError(error));
      return Response.badRequest(
        body: jsonEncode({"success": false, "message": error.runtimeType.toString()}),
      );
    }

    final connectionInfo =
        request.context['shelf.io.connection_info'] as HttpConnectionInfo?;
    final clientIp = connectionInfo?.remoteAddress.address;
    final contentLengthHeader = request.headers['content-length'];
    final totalBytes =
        contentLengthHeader != null ? int.tryParse(contentLengthHeader) : null;

    FormData? fileData;
    await for (final data in formDataRequest.formData) {
      if (data.filename != null) {
        fileData = data;
        break;
      }
    }
    if (fileData == null) {
      final error = ImportNotValid();
      _controller.add(ImportServerError(error));
      return Response.badRequest(
        body: jsonEncode({"success": false, "message": error.runtimeType.toString()}),
      );
    }

    final fileName = fileData.filename ?? 'unnamed_${randomChar(8)}';
    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/${randomChar(16)}_$fileName";
    final tempFile = File(path);
    final sink = tempFile.openWrite();

    _activeSink = sink;
    _activeTempPath = path;
    _cancelRequested = false;

    _controller.add(ImportServerReceiving(
      ipOrigin: clientIp,
      fileName: fileName,
      fileSize: totalBytes,
      progress: 0,
    ));

    final completer = Completer<Response>();
    var received = 0;

    _activeSub = fileData.part.listen(
      (chunk) {
        if (_cancelRequested) return; // subscription is being torn down
        sink.add(chunk);
        received += chunk.length;
        _controller.add(ImportServerReceiving(
          ipOrigin: clientIp,
          fileName: fileName,
          fileSize: totalBytes,
          progress: received,
        ));
      },
      onDone: () async {
        if (_cancelRequested) return; // cleanup already handled by cancel()
        try {
          await sink.flush();
          await sink.close();
          _controller.add(ImportServerComplete(path));
          if (!completer.isCompleted) {
            completer.complete(Response.ok(
              jsonEncode({"success": true, "message": "File sent"}),
            ));
          }
        } catch (e) {
          final error = Exception(e.toString());
          _controller.add(ImportServerError(error));
          if (!completer.isCompleted) {
            completer.complete(Response.internalServerError(body: e.toString()));
          }
        } finally {
          _activeSub = null;
          _activeSink = null;
          _activeTempPath = null;
        }
      },
      onError: (Object e) {
        final error = Exception(e.toString());
        _controller.add(ImportServerError(error));
        if (!completer.isCompleted) {
          completer.complete(Response.internalServerError(body: e.toString()));
        }
        _activeSub = null;
        _activeSink = null;
        _activeTempPath = null;
      },
      cancelOnError: true,
    );

    // If cancel() runs while we're still awaiting the stream, make sure
    // the HTTP response still resolves instead of hanging the client.
    unawaited(() async {
      while (!completer.isCompleted) {
        if (_cancelRequested && _activeSub == null) {
          completer.complete(Response(499, body: jsonEncode({
            "success": false,
            "message": "Cancelled",
          })));
          break;
        }
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }());

    return completer.future;
  }
}