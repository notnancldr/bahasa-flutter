import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bahasa/core/constants/server_routes.dart';
import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:bahasa/core/server/base.dart';
import 'package:bahasa/core/utils/random_char.dart';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import 'dart:developer' as developer;

/// Events emitted by [TransferServer] while it runs.
/// A Bloc (or anything else) subscribes to [TransferServer.events]
/// to track status without touching the server internals.
sealed class TransferServerEvent {}

class TransferServerListening extends TransferServerEvent {
  final String ipHost;
  TransferServerListening(this.ipHost);
}

class TransferServerReceiving extends TransferServerEvent {
  final String? ipOrigin;
  final String fileName;
  final int? fileSize;
  final int progress;
  TransferServerReceiving({
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
    required this.progress,
  });
}

class TransferServerComplete extends TransferServerEvent {
  final String filePath;
  TransferServerComplete(this.filePath);
}

class TransferServerCancelled extends TransferServerEvent {}

class TransferServerError extends TransferServerEvent {
  final Exception error;
  TransferServerError(this.error);
}

/// Owns the Shelf HTTP server used for the local Wi-Fi file-transfer flow.
/// Pure infrastructure — no Bloc/state imports here.
class TransferServer implements TransferServerBase {
  static const _progressInterval = Duration(milliseconds: 100);
  static const _flushThreshold = 512 * 1024; // flush every 512 KB

  HttpServer? _server;
  final _controller = StreamController<TransferServerEvent>.broadcast();

  // Track the in-flight transfer so cancel() can reach into it.
  StreamSubscription<List<int>>? _activeSub;
  IOSink? _activeSink;
  String? _activeTempPath;
  bool _cancelRequested = false;

  Completer<Response>? _activeCompleter;

  @override
  Stream<TransferServerEvent> get events => _controller.stream;

  @override
  bool get isRunning => _server != null;

  @override
  bool get isReceiving => _activeSub != null;

  Router _createHandler() {
    final handler = Router();
    handler.get(checkPath, (Request request) => Response.ok("OK"));
    handler.post(receivePath, _receive);
    return handler;
  }

  @override
  Future<void> start() async {
    await stop();

    developer.log("Starting server", name: "transfer.server");

    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    if (ip == null) {
      final error = NoHostIp();
      _controller.add(TransferServerError(error));
      throw error;
    }

    final handler = _createHandler();
    _server = await io.serve(handler.call, '0.0.0.0', 7000);
    _controller.add(TransferServerListening(ip));
  }

  @override
  Future<void> restart() => start();

  @override
  Future<void> stop() async {
    await _cleanupActiveTransfer(deleteFile: false);
    await _server?.close();
    _server = null;
  }

  /// Cancel the transfer currently in progress, if any. No-op if idle.
  @override
  Future<void> cancel() async {
    if (_activeSub == null) return;
    _cancelRequested = true;
    final completer = _activeCompleter;
    await _cleanupActiveTransfer(deleteFile: true);
    _activeCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(
        Response(
          499,
          body: jsonEncode({"success": false, "message": "Cancelled"}),
        ),
      );
    }
    _controller.add(TransferServerCancelled());
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

  @override
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }

  Response _badRequest() {
    final error = TransferNotValid();
    _controller.add(TransferServerError(error));
    return Response.badRequest(
      body: jsonEncode({
        "success": false,
        "message": error.runtimeType.toString(),
      }),
    );
  }

  Future<Response> _receive(Request request) async {
    developer.log("Receiving", name: "transfer.server");

    final multipart = request.formData();
    if (multipart == null) return _badRequest();

    final clientIp =
        (request.context['shelf.io.connection_info'] as HttpConnectionInfo?)
            ?.remoteAddress
            .address;
    final totalBytes = int.tryParse(request.headers['content-length'] ?? '');

    Response? result;
    await for (final data in multipart.formData) {
      developer.log("[Form data] ${data.filename}", name: "transfer.server");
      // Non-file fields, or anything after the first file: consume and skip.
      if (result != null || data.filename == null) {
        developer.log("[Form data] draining...", name: "transfer.server");
        await data.part.drain<void>();
        developer.log("[Form data] drained", name: "transfer.server");
        continue;
      }
      developer.log("[Form data] saving...", name: "transfer.server");
      result = await _saveFile(data, clientIp, totalBytes);
      developer.log("[Form data] saved", name: "transfer.server");
      if (_cancelRequested) break; // client is being dropped anyway
    }

    return result ?? _badRequest();
  }

  Future<Response> _saveFile(
    FormData data,
    String? clientIp,
    int? totalBytes,
  ) async {
    final fileName = data.filename ?? 'unnamed_${randomChar(8)}';
    // final tempDir = await getTemporaryDirectory();
    // final path = "${tempDir.path}/${randomChar(16)}_$fileName"; // TODO: save to file
    // final sink = File(path).openWrite(); // TODO: save to file

    // _activeSink = sink; // TODO: save to file
    // _activeTempPath = path; // TODO: save to file
    _cancelRequested = false;

    final completer = Completer<Response>();
    _activeCompleter = completer;

    var received = 0;
    var unflushed = 0;
    final clock = Stopwatch()..start();
    var lastEmitMs = 0;

    void emitProgress({bool force = false}) {
      final now = clock.elapsedMilliseconds;
      if (!force && now - lastEmitMs < _progressInterval.inMilliseconds) return;
      lastEmitMs = now;
      _controller.add(
        TransferServerReceiving(
          ipOrigin: clientIp,
          fileName: fileName,
          fileSize: totalBytes,
          progress: received,
        ),
      );
    }

    emitProgress(force: true);

    void reset() {
      _activeSub = null;
      _activeSink = null;
      _activeTempPath = null;
      _activeCompleter = null;
    }

    late final StreamSubscription<List<int>> sub;
    sub = data.part.listen(
      (chunk) {
        // sink.add(chunk);
        received += chunk.length;
        unflushed += chunk.length;
        emitProgress();

        // Backpressure: stop reading from the socket until the disk catches up.
        if (unflushed >= _flushThreshold) {
          unflushed = 0;
          // sub.pause(); // TODO: save to file
          // sink.flush().catchError((_) {}).whenComplete(sub.resume); // TODO: save to file
        }
      },
      onDone: () async {
        try {
          // await sink.flush(); // TODO: save to file
          // await sink.close(); // TODO: save to file
          emitProgress(force: true);
          // _controller.add(TransferServerComplete(path));
          _controller.add(
            TransferServerComplete("dummy"),
          ); // TODO: save to file
          if (!completer.isCompleted) {
            completer.complete(
              Response.ok(
                jsonEncode({"success": true, "message": "File sent"}),
              ),
            );
          }
        } catch (e) {
          _controller.add(TransferServerError(Exception(e.toString())));
          if (!completer.isCompleted) {
            completer.complete(
              Response.internalServerError(body: e.toString()),
            );
          }
        } finally {
          reset();
        }
      },
      onError: (Object e) {
        _controller.add(TransferServerError(Exception(e.toString())));
        if (!completer.isCompleted) {
          completer.complete(Response.internalServerError(body: e.toString()));
        }
        reset();
      },
      cancelOnError: true,
    );
    _activeSub = sub;

    return completer.future;
  }
}
