import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/home/data/datasources/home_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainLoader;
  late DeckDbLoader deckLoader;
  late HomeLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('home_data_source_test_');
    mainLoader = MainDbLoader(() async => tempDir);
    deckLoader = DeckDbLoader(() async => tempDir);
    dataSource = HomeLocalDataSourceImpl(
      mainDbLoader: mainLoader,
      deckDbLoader: deckLoader,
      overrideStorageDirectory: tempDir,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('returns empty dashboard when no decks exist', () async {
    final dashboard = await dataSource.getDashboardData();

    expect(dashboard.hasDecks, isFalse);
    expect(dashboard.streakCount, equals(0));
    expect(dashboard.recommendation, isNull);
    expect(dashboard.recentActivities, isEmpty);
  });

  test('returns active dashboard with streak, recommendation, and recent activities', () async {
    final mainDb = await mainLoader.openDatabase(overrideDirectory: tempDir);
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    // Insert decks
    mainDb.execute('''
      INSERT INTO decks (id, name, language, difficulty, description, rolePlay, explanationRolePlay, activeTime, lastStudiedAt, createdAt, updatedAt)
      VALUES 
        ('deck-1', 'Kosakata JLPT N5', 'ja', 'beginner', 'Desc 1', 'Role 1', 'Exp 1', 1000, ${now.millisecondsSinceEpoch}, 100, 100),
        ('deck-2', 'Tata Bahasa Modul 2', 'ja', 'intermediate', 'Desc 2', 'Role 2', 'Exp 2', 500, NULL, 200, 200);
    ''');

    // Insert daily activity (today and yesterday -> streak 2)
    mainDb.execute('''
      INSERT INTO global_daily_activity (date, activeTime, cardsReviewed, decksStudied)
      VALUES 
        ('$todayStr', 3000, 10, 1),
        ('$yesterdayStr', 4000, 15, 1);
    ''');
    mainDb.close();

    // Populate deck-1 cards
    final deck1Db = await deckLoader.openDeckDatabase(
      'deck-1',
      overrideDirectory: tempDir,
    );
    deck1Db.execute('''
      INSERT INTO cards (idCard, defaultLanguage, translation, phoneticLang, audioPath, additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt)
      VALUES ('c1', 'Hai', 'Yes', NULL, NULL, NULL, 0, 0, 0, 100, 100);
    ''');
    deck1Db.close();

    final dashboard = await dataSource.getDashboardData();

    expect(dashboard.hasDecks, isTrue);
    expect(dashboard.streakCount, equals(2));
    // Deck-2 has null lastStudiedAt, so it should be prioritized as least active recommendation
    expect(dashboard.recommendation, isNotNull);
    expect(dashboard.recommendation!.title, equals('Tata Bahasa Modul 2'));
    expect(
      dashboard.recommendation!.subtitle,
      equals('Belum pernah dipelajari.'),
    );

    expect(dashboard.recentActivities.length, equals(2));
    expect(dashboard.recentActivities.first.title, equals('Kosakata JLPT N5'));
    expect(dashboard.recentActivities.first.cardsCount, equals(1));
  });
}
