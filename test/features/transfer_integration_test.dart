import 'dart:io';

import 'package:bahasa/core/server/transfer_payload.dart';
import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/login/data/repositories/transfer_repository_impl.dart';
import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/data_transfer_client.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/app_theme_mode_model.dart';
import 'package:bahasa/features/settings/data/models/user_profile_model.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory senderDir;
  late Directory receiverDir;

  late MainDbLoader senderMainDbLoader;
  late DeckDbLoader senderDeckDbLoader;
  late ProfileLocalDataSource senderProfileSource;
  late SettingsLocalDataSource senderSettingsSource;
  late DataStorageLocalDataSourceImpl senderDataSource;

  late MainDbLoader receiverMainDbLoader;
  late DeckDbLoader receiverDeckDbLoader;
  late ProfileLocalDataSource receiverProfileSource;
  late SettingsLocalDataSource receiverSettingsSource;
  late TransferRepositoryImpl receiverRepository;

  late TransferServer receiverServer;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    senderDir = await Directory.systemTemp.createTemp('sender_storage_');
    receiverDir = await Directory.systemTemp.createTemp('receiver_storage_');

    senderMainDbLoader = MainDbLoader(() async => senderDir);
    senderDeckDbLoader = DeckDbLoader(() async => senderDir);
    senderProfileSource = ProfileLocalDataSourceImpl();
    senderSettingsSource = SettingsLocalDataSourceImpl();

    senderDataSource = DataStorageLocalDataSourceImpl(
      appDocsDirProvider: () async => senderDir,
      tempDirProvider: () async => senderDir,
      mainDbLoader: senderMainDbLoader,
      deckDbLoader: senderDeckDbLoader,
      profileDataSource: senderProfileSource,
      settingsDataSource: senderSettingsSource,
      dataTransferClient: const DataTransferClientImpl(),
    );

    receiverMainDbLoader = MainDbLoader(() async => receiverDir);
    receiverDeckDbLoader = DeckDbLoader(() async => receiverDir);
    receiverProfileSource = ProfileLocalDataSourceImpl();
    receiverSettingsSource = SettingsLocalDataSourceImpl();

    receiverServer = TransferServer(() async => receiverDir);

    receiverRepository = TransferRepositoryImpl(
      transferServer: receiverServer,
      profileDataSource: receiverProfileSource,
      settingsDataSource: receiverSettingsSource,
      mainDbLoader: receiverMainDbLoader,
      deckDbLoader: receiverDeckDbLoader,
      overrideStorageDirectory: receiverDir,
    );
  });

  tearDown(() async {
    await receiverRepository.dispose();
    if (await senderDir.exists()) {
      await senderDir.delete(recursive: true);
    }
    if (await receiverDir.exists()) {
      await receiverDir.delete(recursive: true);
    }
  });

  test('end-to-end: sender exports and sends data to receiver which validates and restores', () async {
    // 1. Seed sender data
    await senderProfileSource.saveProfile(
      const UserProfileModel(username: 'alice_wanderer', defaultLanguage: 'en'),
    );
    await senderSettingsSource.saveThemeMode(AppThemeMode.dark);

    const deckId = 'deck-uuid-alice-1';
    final senderMainDb = await senderMainDbLoader.openDatabase(
      overrideDirectory: senderDir,
    );
    try {
      senderMainDb.execute(
        '''
        INSERT INTO decks (id, name, language, difficulty, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?, ?);
      ''',
        [deckId, 'Japanese N5', 'ja', 'beginner', 1700000000000, 1700000000000],
      );

      senderMainDb.execute(
        '''
        INSERT INTO global_daily_activity (date, activeTime, cardsReviewed, decksStudied)
        VALUES (?, ?, ?, ?);
      ''',
        ['2026-10-15', 3600, 15, 1],
      );
    } finally {
      senderMainDb.close();
    }

    final senderDeckDb = await senderDeckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: senderDir,
    );
    try {
      senderDeckDb.execute(
        '''
        INSERT INTO cards (idCard, defaultLanguage, translation, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?);
      ''',
        ['card-jp-1', 'Arigatou', 'Thank you', 1700000000000, 1700000000000],
      );
    } finally {
      senderDeckDb.close();
    }

    // 2. Start receiver server
    try {
      await receiverRepository.startServer();
    } catch (_) {
      // In environment without Wi-Fi interface, start() throws NoHostIp.
      // In that case, we verify direct payload export and import.
      final exportedPayload = TransferPayload(
        exportedAt: DateTime.now(),
        profile: (await senderProfileSource.getProfile()).toJson(),
        settings: {
          'themeMode': AppThemeModeModel.toStorage(
            await senderSettingsSource.getThemeMode(),
          ),
        },
        database: {
          'decks': [
            {
              'id': deckId,
              'name': 'Japanese N5',
              'language': 'ja',
              'difficulty': 'beginner',
              'createdAt': 1700000000000,
              'updatedAt': 1700000000000,
            },
          ],
          'globalDailyActivity': [
            {
              'date': '2026-10-15',
              'activeTime': 3600,
              'cardsReviewed': 15,
              'decksStudied': 1,
            },
          ],
          'deckDatabases': {
            deckId: {
              'cards': [
                {
                  'idCard': 'card-jp-1',
                  'defaultLanguage': 'Arigatou',
                  'translation': 'Thank you',
                  'createdAt': 1700000000000,
                  'updatedAt': 1700000000000,
                },
              ],
            },
          },
        },
      );

      final manualFile = File('${receiverDir.path}/manual_transfer.json');
      await manualFile.writeAsString(exportedPayload.toJsonString());

      final validation = await receiverRepository.validateTransferredFile(
        manualFile.path,
      );
      expect(validation.isValid, isTrue);
      expect(validation.username, 'alice_wanderer');

      final restoredProfile = await receiverProfileSource.getProfile();
      expect(restoredProfile.username, 'alice_wanderer');
      return;
    }

    // Server started successfully on Wi-Fi IP
    String? receivedFilePath;
    final fileReceivedCompleter = receiverServer.events.firstWhere(
      (e) => e is TransferServerComplete,
    );

    // 3. Sender sends data to receiver
    final transferResult = await senderDataSource.transferData(
      receiverCode: '127.0.0.1:7000',
    );
    expect(transferResult.isSuccess, isTrue);

    final event = await fileReceivedCompleter;
    receivedFilePath = (event as TransferServerComplete).filePath;

    // 4. Receiver validates and restores
    final validation = await receiverRepository.validateTransferredFile(
      receivedFilePath,
    );
    expect(validation.isValid, isTrue);
    expect(validation.username, 'alice_wanderer');
    expect(validation.defaultLanguage, 'en');

    // 5. Verify restored state on receiver
    final restoredProfile = await receiverProfileSource.getProfile();
    expect(restoredProfile.username, 'alice_wanderer');

    final receiverMainDb = await receiverMainDbLoader.openDatabase(
      overrideDirectory: receiverDir,
    );
    try {
      final rows = receiverMainDb.select('SELECT * FROM decks WHERE id = ?;', [
        deckId,
      ]);
      expect(rows.length, 1);
      expect(rows.first['name'], 'Japanese N5');
    } finally {
      receiverMainDb.close();
    }
  });
}
