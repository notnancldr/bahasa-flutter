import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/study/data/datasources/study_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late StudyLocalDataSourceImpl studyDataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('study_ds_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    studyDataSource = StudyLocalDataSourceImpl(
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

  test('startSession, recordAnswer, and completeSession persist to sessions, logs, cards, daily_deck_stats, and basa.sqlite', () async {
    const deckId = 'deck_study_1';
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final mainDb = await mainDbLoader.openDatabase(overrideDirectory: tempDir);
    try {
      mainDb.execute(
        '''
          INSERT INTO decks (
            id, name, language, difficulty, activeTime, createdAt, updatedAt
          ) VALUES (?, ?, ?, ?, 0, ?, ?);
        ''',
        [deckId, 'Japanese 101', 'ja', 'beginner', nowMs, nowMs],
      );
    } finally {
      mainDb.close();
    }

    final deckDb = await deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: tempDir,
    );
    try {
      deckDb.execute(
        '''
          INSERT INTO cards (
            idCard, defaultLanguage, translation, phoneticLang,
            additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt
          ) VALUES
            ('c1', 'Halo', 'Konnichiwa', '/kon/', 'Sapaan', 0, 0, 0, ?, ?),
            ('c2', 'Selamat tinggal', 'Sayounara', '/sa/', 'Pisah', 0, 0, 0, ?, ?);
        ''',
        [nowMs, nowMs, nowMs, nowMs],
      );
    } finally {
      deckDb.close();
    }

    final sessionCards = await studyDataSource.getSessionCards(deckId);
    expect(sessionCards.length, equals(2));

    final sessionId = await studyDataSource.startSession(
      deckId: deckId,
      gameType: 'quiz',
      totalQuestions: 2,
    );

    await studyDataSource.recordAnswer(
      deckId: deckId,
      sessionId: sessionId,
      cardId: 'c1',
      questionType: 'translating',
      isCorrect: true,
      timeSpentMs: 1500,
    );
    await studyDataSource.recordAnswer(
      deckId: deckId,
      sessionId: sessionId,
      cardId: 'c2',
      questionType: 'writing',
      isCorrect: false,
      timeSpentMs: 2200,
    );

    final result = await studyDataSource.completeSession(
      deckId: deckId,
      sessionId: sessionId,
      gameType: 'quiz',
      startedAtMs: nowMs - 5000,
      outcomes: const [true, false],
    );

    expect(result.correctCount, equals(1));
    expect(result.wrongCount, equals(1));
    expect(result.totalQuestions, equals(2));

    // Verify updated card stats
    final updatedCards = await studyDataSource.getAllDeckCards(deckId);
    final c1 = updatedCards.firstWhere((c) => c.idCard == 'c1');
    final c2 = updatedCards.firstWhere((c) => c.idCard == 'c2');
    expect(c1.reps, equals(1));
    expect(c1.correctAnswer, equals(1));
    expect(c1.finalScore, equals(100));
    expect(c2.reps, equals(1));
    expect(c2.correctAnswer, equals(0));
    expect(c2.finalScore, equals(0));

    // Verify global_daily_activity in basa.sqlite
    final checkMainDb = await mainDbLoader.openDatabase(
      overrideDirectory: tempDir,
    );
    try {
      final globalRows = checkMainDb.select(
        'SELECT cardsReviewed, decksStudied FROM global_daily_activity;',
      );
      expect(globalRows.length, equals(1));
      expect(globalRows.first['cardsReviewed'], equals(2));
      expect(globalRows.first['decksStudied'], equals(1));
    } finally {
      checkMainDb.close();
    }
  });
}
