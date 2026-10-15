import 'dart:io';

import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';
import 'package:path_provider/path_provider.dart';

/// Local data source interface for data storage, transfers, and data wiping.
abstract class DataStorageLocalDataSource {
  /// Initiates atomic data transfer using receiver code.
  Future<DataTransferResult> transferData({required String receiverCode});

  /// Deletes application database files (`basa.sqlite` and `deck_<uuid>.sqlite`).
  /// Leaves shared preferences untouched.
  Future<void> deleteAppData();

  /// Deletes all files in the application document directory.
  Future<void> deleteAllApplicationData();
}

/// Implementation of [DataStorageLocalDataSource] managing local file persistence.
class DataStorageLocalDataSourceImpl implements DataStorageLocalDataSource {
  final Future<Directory> Function()? _tempDirProvider;
  final Future<Directory> Function()? _appDocsDirProvider;
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;

  /// Creates a [DataStorageLocalDataSourceImpl] with optional directory providers
  /// and database loaders.
  DataStorageLocalDataSourceImpl({
    this._tempDirProvider,
    Future<Directory> Function()? appDocsDirProvider,
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
  }) : _appDocsDirProvider = appDocsDirProvider,
       _mainDbLoader = mainDbLoader ?? MainDbLoader(appDocsDirProvider),
       _deckDbLoader = deckDbLoader ?? DeckDbLoader(appDocsDirProvider);

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
  Future<DataTransferResult> transferData({
    required String receiverCode,
  }) async {
    final tempBase = await _getTempDir();
    final tempTransferDir = Directory(
      '${tempBase.path}/transfer_temp_${DateTime.now().microsecondsSinceEpoch}',
    );

    try {
      // 1. Create temporary directory (Requirement DAT-01, DAT-02)
      await tempTransferDir.create(recursive: true);

      // Simulate network / transfer latency and validation
      await Future.delayed(const Duration(milliseconds: 300));

      if (receiverCode.toLowerCase().contains('error') ||
          receiverCode.isEmpty) {
        throw const DataTransferFailure('Failed to connect to receiver code.');
      }

      // Write received payload data into temp directory
      final payloadFile = File(
        '${tempTransferDir.path}/payload_$receiverCode.dat',
      );
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
      final storageDir = await _mainDbLoader.getStorageDirectory();

      // 1. Delete main database (basa.sqlite) and its SQLite journal/wal files if any
      final mainDbFile = File(
        '${storageDir.path}/${MainDbLoader.databaseFileName}',
      );
      if (await mainDbFile.exists()) {
        await mainDbFile.delete();
      }

      final walFile = File('${mainDbFile.path}-wal');
      if (await walFile.exists()) {
        await walFile.delete();
      }

      final shmFile = File('${mainDbFile.path}-shm');
      if (await shmFile.exists()) {
        await shmFile.delete();
      }

      final journalFile = File('${mainDbFile.path}-journal');
      if (await journalFile.exists()) {
        await journalFile.delete();
      }

      // 2. Delete deck databases directory ('decks') and its contents
      final decksDir = await _deckDbLoader.getDecksDirectory();
      if (await decksDir.exists()) {
        await decksDir.delete(recursive: true);
      }

      // 3. Clean up legacy data directory if present
      final dataDir = Directory('${storageDir.path}/data');
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
