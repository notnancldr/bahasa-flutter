import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/deck_history/data/datasources/deck_history_local_data_source.dart';
import 'package:bahasa/features/decks/deck_history/data/repositories/deck_history_repository_impl.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late DeckHistoryLocalDataSourceImpl dataSource;
  late DeckHistoryRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('deck_history_ds_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    dataSource = DeckHistoryLocalDataSourceImpl(
      mainDbLoader: mainDbLoader,
      deckDbLoader: deckDbLoader,
      overrideStorageDirectory: tempDir,
    );
    repository = DeckHistoryRepositoryImpl(localDataSource: dataSource);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('single deck and multi-deck history querying and card logs', () async {
    const deck1 = 'deck_test_1';
    const deck2 = 'deck_test_2';
    final now = DateTime(2026, 10, 16, 14, 0);
    final nowMs = now.millisecondsSinceEpoch;

    // 1. Insert decks into basa.sqlite
    final mainDb = await mainDbLoader.openDatabase(overrideDirectory: tempDir);
    try {
      mainDb.execute(
        '''
        INSERT INTO decks (
          id, name, language, difficulty, description, activeTime,
          lastStudiedAt, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        [
          deck1,
          'Kosakata Bahasa Jepang',
          'ja',
          'beginner',
          'Sapaan dasar',
          120000,
          nowMs,
          nowMs,
          nowMs,
        ],
      );
      mainDb.execute(
        '''
        INSERT INTO decks (
          id, name, language, difficulty, description, activeTime,
          lastStudiedAt, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        [
          deck2,
          'English Vocabulary',
          'en',
          'intermediate',
          'Daily verbs',
          60000,
          nowMs,
          nowMs,
          nowMs,
        ],
      );
    } finally {
      mainDb.close();
    }

    // 2. Insert sessions and cards into deck1
    final db1 = await deckDbLoader.openDeckDatabase(
      deck1,
      overrideDirectory: tempDir,
    );
    try {
      db1.execute('''
        INSERT INTO cards (idCard, defaultLanguage, translation, reps, correctAnswer, finalScore, createdAt, updatedAt)
        VALUES ('card_1', 'Konnichiwa', 'Halo', 1, 1, 100, $nowMs, $nowMs);
      ''');
      db1.execute('''
        INSERT INTO cards (idCard, defaultLanguage, translation, reps, correctAnswer, finalScore, createdAt, updatedAt)
        VALUES ('card_2', 'Arigatou', 'Terima kasih', 1, 0, 0, $nowMs, $nowMs);
      ''');

      db1.execute('''
        INSERT INTO sessions (idSession, gameType, startedAt, completedAt, totalQuestions, correctCount, finalScore, duration)
        VALUES ('ses_1', 'quiz', ${nowMs - 60000}, $nowMs, 10, 9, 90.0, 60000);
      ''');

      db1.execute('''
        INSERT INTO logs (idLog, idSession, idCard, questionType, isCorrect, timeSpent, timestamp)
        VALUES ('log_1', 'ses_1', 'card_1', 'mc', 1.0, 5000, ${nowMs - 30000});
      ''');
      db1.execute('''
        INSERT INTO logs (idLog, idSession, idCard, questionType, isCorrect, timeSpent, timestamp)
        VALUES ('log_2', 'ses_1', 'card_2', 'mc', 0.0, 7000, ${nowMs - 10000});
      ''');
    } finally {
      db1.close();
    }

    // 3. Insert sessions into deck2
    final db2 = await deckDbLoader.openDeckDatabase(
      deck2,
      overrideDirectory: tempDir,
    );
    try {
      db2.execute('''
        INSERT INTO sessions (idSession, gameType, startedAt, completedAt, totalQuestions, correctCount, finalScore, duration)
        VALUES ('ses_2', 'flashcard', ${nowMs - 120000}, ${nowMs - 60000}, 5, 5, 100.0, 60000);
      ''');
    } finally {
      db2.close();
    }

    // Test A: Single Deck history items
    final singleDeckItems = await repository.getHistoryItems(
      deckId: deck1,
      period: DeckHistoryPeriod.week,
      referenceDate: now,
    );
    expect(singleDeckItems.length, 1);
    expect(singleDeckItems.first.sessionId, 'ses_1');
    expect(singleDeckItems.first.deckName, 'Kosakata Bahasa Jepang');
    expect(singleDeckItems.first.isQuiz, isTrue);
    expect(singleDeckItems.first.correctCount, 9);
    expect(singleDeckItems.first.totalQuestions, 10);

    // Test B: Global / All Decks history items
    final allItems = await repository.getHistoryItems(
      deckId: null,
      period: DeckHistoryPeriod.week,
      referenceDate: now,
    );
    expect(allItems.length, 2);
    expect(allItems[0].sessionId, 'ses_1'); // newer
    expect(allItems[1].sessionId, 'ses_2'); // older
    expect(allItems[1].deckName, 'English Vocabulary');
    expect(allItems[1].isFlashcard, isTrue);

    // Test C: Summary calculation
    final summary = await repository.getHistorySummary(
      deckId: null,
      period: DeckHistoryPeriod.week,
      referenceDate: now,
    );
    expect(summary.totalActivities, 2);
    expect(summary.totalDurationMs, 120000);
    // (9 + 5) / (10 + 5) = 14 / 15 = 93.3% -> 93%
    expect(summary.averageAccuracy, 93);

    // Test D: Card Logs for ses_1
    final cardLogs = await repository.getSessionCardLogs(
      deckId: deck1,
      sessionId: 'ses_1',
    );
    expect(cardLogs.length, 2);
    expect(cardLogs[0].cardId, 'card_1');
    expect(cardLogs[0].defaultLanguage, 'Konnichiwa');
    expect(cardLogs[0].translation, 'Halo');
    expect(cardLogs[0].isCorrect, isTrue);

    expect(cardLogs[1].cardId, 'card_2');
    expect(cardLogs[1].defaultLanguage, 'Arigatou');
    expect(cardLogs[1].translation, 'Terima kasih');
    expect(cardLogs[1].isCorrect, isFalse);
  });
}
