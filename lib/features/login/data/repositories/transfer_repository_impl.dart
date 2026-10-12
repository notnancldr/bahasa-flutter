import 'dart:io';

import 'package:bahasa/core/server/base.dart';
import 'package:bahasa/core/server/simulated_server.dart';
import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/features/login/domain/entities/transfer_validation_result.dart';
import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferServerBase _transferServer;

  TransferRepositoryImpl({TransferServerBase? transferServer})
    : _transferServer = transferServer ?? TransferServer();

  @override
  Stream<TransferServerEvent> get events => _transferServer.events;

  @override
  Future<void> startServer() async {
    await _transferServer.start();
  }

  @override
  Future<void> restartServer() async {
    await _transferServer.restart();
  }

  @override
  Future<void> cancelServer() async {
    await _transferServer.cancel();
    await _transferServer.stop();
  }

  @override
  Future<TransferValidationResult> validateTransferredFile(
    String? tempFilePath,
  ) async {
    if (tempFilePath == null || tempFilePath.isEmpty) {
      return const TransferValidationResult(
        isValid: false,
        errorMessage: 'File path is missing or invalid.',
      );
    }

    // Simulate validation check
    await Future.delayed(const Duration(milliseconds: 1500));

    // If file is simulated error or doesn't exist (when not simulated dummy)
    if (tempFilePath.contains('invalid') || tempFilePath.contains('error')) {
      await cleanupTempFiles(tempFilePath);
      return const TransferValidationResult(
        isValid: false,
        errorMessage: 'Corrupted data or transfer aborted.',
      );
    }

    // Check actual file if it exists on disk
    if (!tempFilePath.contains('dummy') &&
        !tempFilePath.contains('simulated')) {
      final file = File(tempFilePath);
      if (!await file.exists()) {
        return const TransferValidationResult(
          isValid: false,
          errorMessage: 'Transferred file not found.',
        );
      }
    }

    return const TransferValidationResult(
      isValid: true,
      username: 'nandaahmad',
      defaultLanguage: 'id',
    );
  }

  @override
  Future<void> cleanupTempFiles([String? tempFilePath]) async {
    if (tempFilePath != null && tempFilePath.isNotEmpty) {
      try {
        final file = File(tempFilePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }

  @override
  Future<void> dispose() async {
    await _transferServer.dispose();
  }
}
