// simulated_transfer_server.dart
import 'dart:async';

import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:bahasa/core/server/base.dart';
import 'package:bahasa/core/server/transfer_server.dart';

// + import TransferServerBase and the TransferServerEvent classes

enum SimulatedOutcome {
  success, // runs to 100% and completes
  errorMidway, // emits progress, then TransferServerError
  invalidRequest, // immediately emits TransferNotValid (no file part)
}

class SimulatedTransfer {
  final String fileName;
  final int fileSize;
  final int chunkSize;
  final Duration tick;
  final String clientIp;
  final SimulatedOutcome outcome;

  /// For [SimulatedOutcome.errorMidway]: fraction (0..1) at which it fails.
  final double failAt;

  const SimulatedTransfer({
    this.fileName = 'sample_video.mp4',
    this.fileSize = 25 * 1024 * 1024,
    this.chunkSize = 256 * 1024,
    this.tick = const Duration(milliseconds: 100),
    this.clientIp = '192.168.1.42',
    this.outcome = SimulatedOutcome.success,
    this.failAt = 0.6,
  });

  /// Slow transfer, handy for testing the cancel button.
  const SimulatedTransfer.slow()
    : fileName = 'big_file.zip',
      fileSize = 200 * 1024 * 1024,
      chunkSize = 512 * 1024,
      tick = const Duration(milliseconds: 150),
      clientIp = '192.168.1.42',
      outcome = SimulatedOutcome.success,
      failAt = 0.6;
}

class SimulatedTransferServer implements TransferServerBase {
  SimulatedTransferServer({
    this.ip = '192.168.1.10',
    this.startDelay = const Duration(milliseconds: 400),
    this.simulateNoWifi = false,
  });

  final String ip;
  final Duration startDelay;

  /// When true, start() behaves like getWifiIP() returned null.
  bool simulateNoWifi;

  final _controller = StreamController<TransferServerEvent>.broadcast();
  Timer? _timer;
  bool _running = false;

  @override
  Stream<TransferServerEvent> get events => _controller.stream;
  @override
  bool get isRunning => _running;
  @override
  bool get isReceiving => _timer != null;

  @override
  Future<void> start() async {
    await stop();
    await Future.delayed(startDelay);

    if (simulateNoWifi) {
      final error = NoHostIp();
      _controller.add(TransferServerError(error));
      throw error;
    }

    _running = true;
    _controller.add(TransferServerListening(ip));
  }

  @override
  Future<void> restart() => start();

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  @override
  Future<void> cancel() async {
    if (_timer == null) return;
    _timer!.cancel();
    _timer = null;
    _controller.add(TransferServerCancelled());
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }

  /// Pretend a phone just started uploading a file to us.
  /// Call this from a debug button or a test.
  Future<void> simulateIncoming([
    SimulatedTransfer transfer = const SimulatedTransfer(),
  ]) async {
    if (!_running) {
      throw StateError('Server not running; call start() first.');
    }
    if (isReceiving) return; // one transfer at a time, like the real one

    if (transfer.outcome == SimulatedOutcome.invalidRequest) {
      _controller.add(TransferServerError(TransferNotValid()));
      return;
    }

    var received = 0;
    _controller.add(
      TransferServerReceiving(
        ipOrigin: transfer.clientIp,
        fileName: transfer.fileName,
        fileSize: transfer.fileSize,
        progress: 0,
      ),
    );

    _timer = Timer.periodic(transfer.tick, (t) {
      received = (received + transfer.chunkSize).clamp(0, transfer.fileSize);

      if (transfer.outcome == SimulatedOutcome.errorMidway &&
          received / transfer.fileSize >= transfer.failAt) {
        t.cancel();
        _timer = null;
        _controller.add(
          TransferServerError(Exception('Simulated connection reset')),
        );
        return;
      }

      _controller.add(
        TransferServerReceiving(
          ipOrigin: transfer.clientIp,
          fileName: transfer.fileName,
          fileSize: transfer.fileSize,
          progress: received,
        ),
      );

      if (received >= transfer.fileSize) {
        t.cancel();
        _timer = null;
        _controller.add(
          TransferServerComplete('/tmp/simulated/${transfer.fileName}'),
        );
      }
    });
  }
}
