import 'dart:io';

import 'package:bahasa/core/server/transfer_payload.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/login/data/repositories/transfer_repository_impl.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late ProfileLocalDataSource profileDataSource;
  late SettingsLocalDataSource settingsDataSource;
  late TransferRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('transfer_repo_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    profileDataSource = ProfileLocalDataSourceImpl();
    settingsDataSource = SettingsLocalDataSourceImpl();

    repository = TransferRepositoryImpl(
      profileDataSource: profileDataSource,
      settingsDataSource: settingsDataSource,
      mainDbLoader: mainDbLoader,
      deckDbLoader: deckDbLoader,
      overrideStorageDirectory: tempDir,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'validateTransferredFile restores profile, settings, and SQLite databases',
    () async {
      const deckId = 'test-deck-123';
      final payload = TransferPayload(
        exportedAt: DateTime.parse('2026-10-15T12:00:00.000Z'),
        profile: {
          'username': 'ahmad_test',
          'default_language': 'id',
          'updated_at': '2026-05-01T10:00:00.000Z',
        },
        settings: {'themeMode': 'dark', 'notificationsEnabled': false},
        database: {
          'decks': [
            {
              'id': deckId,
              'name': 'Indonesian Basics',
              'language': 'id',
              'difficulty': 'beginner',
              'description': 'Basic words',
              'rolePlay': null,
              'explanationRolePlay': null,
              'activeTime': 5000,
              'lastStudiedAt': 1700000000000,
              'createdAt': 1690000000000,
              'updatedAt': 1700000000000,
            },
          ],
          'globalDailyActivity': [
            {
              'date': '2026-10-15',
              'activeTime': 5000,
              'cardsReviewed': 10,
              'decksStudied': 1,
            },
          ],
          'deckDatabases': {
            deckId: {
              'cards': [
                {
                  'idCard': 'card-1',
                  'defaultLanguage': 'Selamat pagi',
                  'translation': 'Good morning',
                  'phoneticLang': 'sə-la-mat pa-gi',
                  'audioPath': null,
                  'additionalContext': null,
                  'reps': 3,
                  'correctAnswer': 3,
                  'finalScore': 100,
                  'createdAt': 1690000000000,
                  'updatedAt': 1700000000000,
                },
              ],
              'sessions': [],
              'logs': [],
              'dailyDeckStats': [],
            },
          },
        },
      );

      final payloadFile = File('${tempDir.path}/test_bundle.json');
      await payloadFile.writeAsString(payload.toJsonString());

      final result = await repository.validateTransferredFile(payloadFile.path);

      // 1. Verify validation result
      expect(result.isValid, isTrue);
      expect(result.username, 'ahmad_test');
      expect(result.defaultLanguage, 'id');
      expect(result.joinSince, '2026-05-01T10:00:00.000Z');

      // 2. Verify Profile restored
      final profile = await profileDataSource.getProfile();
      expect(profile.username, 'ahmad_test');
      expect(profile.defaultLanguage, 'id');

      // 3. Verify Settings restored
      final theme = await settingsDataSource.getThemeMode();
      expect(theme, AppThemeMode.dark);
      final notif = await settingsDataSource.getNotificationSettings();
      expect(notif.isEnabled, isFalse);

      // 4. Verify basa.sqlite restored
      final mainDb = await mainDbLoader.openDatabase(
        overrideDirectory: tempDir,
      );
      try {
        final deckRows = mainDb.select('SELECT * FROM decks WHERE id = ?;', [
          deckId,
        ]);
        expect(deckRows.length, 1);
        expect(deckRows.first['name'], 'Indonesian Basics');

        final activityRows = mainDb.select(
          'SELECT * FROM global_daily_activity;',
        );
        expect(activityRows.length, 1);
        expect(activityRows.first['cardsReviewed'], 10);
      } finally {
        mainDb.close();
      }

      // 5. Verify deck_<uuid>.sqlite restored
      final deckDb = await deckDbLoader.openDeckDatabase(
        deckId,
        overrideDirectory: tempDir,
      );
      try {
        final cardRows = deckDb.select(
          'SELECT * FROM cards WHERE idCard = ?;',
          ['card-1'],
        );
        expect(cardRows.length, 1);
        expect(cardRows.first['translation'], 'Good morning');
      } finally {
        deckDb.close();
      }

      // 6. Verify temp file cleaned up
      expect(await payloadFile.exists(), isFalse);
    },
  );

  test(
    'validateTransferredFile returns invalid when JSON is corrupt',
    () async {
      final corruptFile = File('${tempDir.path}/corrupt.json');
      await corruptFile.writeAsString('not a valid json');

      final result = await repository.validateTransferredFile(corruptFile.path);
      expect(result.isValid, isFalse);
    },
  );
}
