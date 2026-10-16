import 'dart:io';

import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/core/server/transfer_payload.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/settings/data/datasources/data_transfer_client.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/app_theme_mode_model.dart';
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
  final ProfileLocalDataSource? _profileDataSource;
  final SettingsLocalDataSource? _settingsDataSource;
  final DataTransferClient _dataTransferClient;

  /// Creates a [DataStorageLocalDataSourceImpl] with optional directory providers,
  /// database loaders, profile/settings sources, and data transfer client.
  DataStorageLocalDataSourceImpl({
    this._tempDirProvider,
    Future<Directory> Function()? appDocsDirProvider,
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
    this._profileDataSource,
    this._settingsDataSource,
    DataTransferClient? dataTransferClient,
  }) : _appDocsDirProvider = appDocsDirProvider,
       _mainDbLoader = mainDbLoader ?? MainDbLoader(appDocsDirProvider),
       _deckDbLoader = deckDbLoader ?? DeckDbLoader(appDocsDirProvider),
       _dataTransferClient =
           dataTransferClient ?? const DataTransferClientImpl();

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
      // 1. Resolve receiver URI and verify connectivity
      final targetUri = _dataTransferClient.resolveReceiverUri(receiverCode);
      final isReceiverOnline = await _dataTransferClient.checkReceiver(
        targetUri,
      );
      if (!isReceiverOnline) {
        throw DataTransferFailure(
          'Could not reach receiver at $receiverCode. Please ensure both devices are connected to the same Wi-Fi.',
        );
      }

      // 2. Create temporary directory (Requirement DAT-01, DAT-02)
      await tempTransferDir.create(recursive: true);

      // 3. Export profile data
      Map<String, dynamic> profileJson = {};
      try {
        final profile = await _profileDataSource?.getProfile();
        if (profile != null) {
          profileJson = profile.toJson();
        }
      } catch (_) {}

      // 4. Export settings data
      Map<String, dynamic> settingsJson = {};
      try {
        final theme = await _settingsDataSource?.getThemeMode();
        final notif = await _settingsDataSource?.getNotificationSettings();
        settingsJson = {
          if (theme != null) 'themeMode': AppThemeModeModel.toStorage(theme),
          if (notif != null) 'notificationsEnabled': notif.isEnabled,
        };
      } catch (_) {}

      // 5. Export SQLite databases (basa.sqlite & decks/*.sqlite)
      final appDocsDir = await _getAppDocsDir();
      final List<Map<String, dynamic>> decks = [];
      final List<Map<String, dynamic>> activities = [];

      try {
        final mainDb = await _mainDbLoader.openDatabase(
          overrideDirectory: appDocsDir,
        );
        try {
          final deckRows = mainDb.select('SELECT * FROM decks;');
          for (final row in deckRows) {
            decks.add(Map<String, dynamic>.from(row));
          }

          final activityRows = mainDb.select(
            'SELECT * FROM global_daily_activity;',
          );
          for (final row in activityRows) {
            activities.add(Map<String, dynamic>.from(row));
          }
        } finally {
          mainDb.close();
        }
      } catch (_) {}

      final Map<String, dynamic> deckDatabases = {};
      try {
        final decksDir = await _deckDbLoader.getDecksDirectory(
          overrideDirectory: appDocsDir,
        );
        if (await decksDir.exists()) {
          final files = await decksDir.list().toList();
          for (final file in files) {
            if (file is File && file.path.endsWith('.sqlite')) {
              final fileName = file.uri.pathSegments.last;
              final match = RegExp(r'^deck_(.+)\.sqlite$').firstMatch(fileName);
              if (match != null) {
                final deckId = match.group(1)!;
                final deckDb = await _deckDbLoader.openDeckDatabase(
                  deckId,
                  overrideDirectory: appDocsDir,
                );
                try {
                  final cards = deckDb
                      .select('SELECT * FROM cards;')
                      .map((r) => Map<String, dynamic>.from(r))
                      .toList();
                  final sessions = deckDb
                      .select('SELECT * FROM sessions;')
                      .map((r) => Map<String, dynamic>.from(r))
                      .toList();
                  final logs = deckDb
                      .select('SELECT * FROM logs;')
                      .map((r) => Map<String, dynamic>.from(r))
                      .toList();
                  final stats = deckDb
                      .select('SELECT * FROM daily_deck_stats;')
                      .map((r) => Map<String, dynamic>.from(r))
                      .toList();

                  deckDatabases[deckId] = {
                    'cards': cards,
                    'sessions': sessions,
                    'logs': logs,
                    'dailyDeckStats': stats,
                  };
                } finally {
                  deckDb.close();
                }
              }
            }
          }
        }
      } catch (_) {}

      // 6. Assemble payload and write to temporary file
      final payload = TransferPayload(
        exportedAt: DateTime.now(),
        profile: profileJson,
        settings: settingsJson,
        database: {
          'decks': decks,
          'globalDailyActivity': activities,
          'deckDatabases': deckDatabases,
        },
      );

      final payloadFile = File(
        '${tempTransferDir.path}/bahasa_transfer_bundle.json',
      );
      await payloadFile.writeAsString(payload.toJsonString());

      // 7. Send payload file to receiver device
      final bytesTransferred = await _dataTransferClient.sendTransferFile(
        targetUri,
        payloadFile,
      );

      return DataTransferResult(
        isSuccess: true,
        message: 'Data transfer completed successfully.',
        bytesTransferred: bytesTransferred,
      );
    } catch (e) {
      if (e is SettingsFailure) rethrow;
      throw DataTransferFailure(e.toString());
    } finally {
      // 8. Temporary directory is ALWAYS cleaned up on success or failure (DAT-02)
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
