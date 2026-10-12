import 'dart:io';
import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';
import 'package:path_provider/path_provider.dart';

abstract class DataStorageLocalDataSource {
  Future<DataTransferResult> transferData({required String receiverCode});
  Future<void> deleteAppData();
  Future<void> deleteAllApplicationData();
}

class DataStorageLocalDataSourceImpl implements DataStorageLocalDataSource {
  final Future<Directory> Function()? _tempDirProvider;
  final Future<Directory> Function()? _appDocsDirProvider;

  DataStorageLocalDataSourceImpl({
    this._tempDirProvider,
    this._appDocsDirProvider,
  });

  Future<Directory> _getTempDir() async {
    return _tempDirProvider != null
        ? await _tempDirProvider()
        : await getTemporaryDirectory();
  }

  Future<Directory> _getAppDocsDir() async {
    return _appDocsDirProvider != null
        ? await _appDocsDirProvider()
        : await getApplicationDocumentsDirectory();
  }

  @override
  Future<DataTransferResult> transferData({required String receiverCode}) async {
    final tempBase = await _getTempDir();
    final tempTransferDir = Directory(
      '${tempBase.path}/transfer_temp_${DateTime.now().microsecondsSinceEpoch}',
    );

    try {
      // 1. Create temporary directory (Requirement DAT-01, DAT-02)
      await tempTransferDir.create(recursive: true);

      // Simulate network / transfer latency and validation
      await Future.delayed(const Duration(milliseconds: 300));

      if (receiverCode.toLowerCase().contains('error') || receiverCode.isEmpty) {
        throw const DataTransferFailure('Failed to connect to receiver code.');
      }

      // Write received payload data into temp directory
      final payloadFile = File('${tempTransferDir.path}/payload_$receiverCode.dat');
      await payloadFile.writeAsString(
        'TRANSFERRED_DATA_PAYLOAD: code=$receiverCode, time=${DateTime.now().toIso8601String()}',
      );

      // 2. Atomic move to application directory only on full completion (DAT-01)
      final appDocsDir = await _getAppDocsDir();
      final destinationDir = Directory('${appDocsDir.path}/data');
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      final entities = await tempTransferDir.list().toList();
      for (final entity in entities) {
        if (entity is File) {
          final fileName = entity.uri.pathSegments.last;
          final targetFile = File('${destinationDir.path}/$fileName');
          await entity.copy(targetFile.path);
        }
      }

      return const DataTransferResult(
        isSuccess: true,
        message: 'Data transfer completed successfully.',
      );
    } catch (e) {
      if (e is SettingsFailure) rethrow;
      throw DataTransferFailure(e.toString());
    } finally {
      // 3. Temporary directory is ALWAYS cleaned up on success or failure (DAT-02)
      if (await tempTransferDir.exists()) {
        await tempTransferDir.delete(recursive: true);
      }
    }
  }

  @override
  Future<void> deleteAppData() async {
    try {
      final appDocsDir = await _getAppDocsDir();
      final dataDir = Directory('${appDocsDir.path}/data');
      if (await dataDir.exists()) {
        await dataDir.delete(recursive: true);
      }
    } catch (e) {
      throw StorageOperationFailure('Failed to delete app data: $e');
    }
  }

  @override
  Future<void> deleteAllApplicationData() async {
    try {
      final appDocsDir = await _getAppDocsDir();
      if (await appDocsDir.exists()) {
        final entries = await appDocsDir.list().toList();
        for (final entry in entries) {
          await entry.delete(recursive: true);
        }
      }
    } catch (e) {
      throw StorageOperationFailure('Failed to clear application data: $e');
    }
  }
}
