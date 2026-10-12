import 'package:bahasa/core/server/transfer_server.dart';

abstract class TransferServerBase {
  Stream<TransferServerEvent> get events;
  bool get isRunning;
  bool get isReceiving;

  Future<void> start();
  Future<void> restart();
  Future<void> stop();
  Future<void> cancel();
  Future<void> dispose();
}