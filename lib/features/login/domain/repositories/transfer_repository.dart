import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/features/login/domain/entities/transfer_validation_result.dart';

abstract class TransferRepository {
  /// Stream of transfer server events.
  Stream<TransferServerEvent> get events;

  /// Starts or restarts the server to listen for incoming connections.
  Future<void> startServer();

  /// Restarts the server.
  Future<void> restartServer();

  /// Stops or cancels an active transfer.
  Future<void> cancelServer();

  /// Validates a transferred file integrity.
  Future<TransferValidationResult> validateTransferredFile(
    String? tempFilePath,
  );

  /// Cleans up any leftover temporary files.
  Future<void> cleanupTempFiles([String? tempFilePath]);

  /// Disposes background server resources.
  Future<void> dispose();
}
