import 'dart:io';
import 'dart:math';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/core/utils/random_char.dart';
import 'package:bahasa/features/decks/deck_details/data/datasources/deck_details_local_data_source.dart';
import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

import '../../domain/entities/study_session_result.dart';

/// Local SQLite data source contract for Flashcard and Quiz study sessions.
abstract class StudyLocalDataSource {
  /// Returns all cards in [deckId].
  Future<List<DeckCardItem>> getAllDeckCards(String deckId);

  /// Returns up to [limit] shuffled cards from [deckId].
  Future<List<DeckCardItem>> getSessionCards(String deckId, {int limit = 10});

  /// Creates a new row in `sessions` and returns its `idSession`.
  Future<String> startSession({
    required String deckId,
    required String gameType,
    required int totalQuestions,
  });

  /// Inserts a question log into `logs` and updates `cards` mastery stats.
  Future<void> recordAnswer({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  });

  /// Finalizes `sessions`, updates `daily_deck_stats`, and updates `basa.sqlite`
  /// (`decks` and `global_daily_activity`).
  Future<StudySessionResult> completeSession({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  });
}

/// SQLite implementation of [StudyLocalDataSource].
class StudyLocalDataSourceImpl implements StudyLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  /// Creates a [StudyLocalDataSourceImpl].
  const StudyLocalDataSourceImpl({
    this._mainDbLoader = const MainDbLoader(),
    this._deckDbLoader = const DeckDbLoader(),
    this._overrideStorageDirectory,
  });

  @override
  Future<List<DeckCardItem>> getAllDeckCards(String deckId) async {
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = deckDb.select('''
        SELECT idCard, defaultLanguage, translation, phoneticLang, additionalContext,
               reps, correctAnswer, finalScore
        FROM cards
        ORDER BY createdAt ASC, idCard ASC;
      ''');

      return rows.map((row) {
        return DeckCardItem(
          idCard: row['idCard'] as String,
          defaultLanguage: row['defaultLanguage'] as String? ?? '',
          translation: row['translation'] as String? ?? '',
          phoneticLang: row['phoneticLang'] as String? ?? '',
          additionalContext: row['additionalContext'] as String? ?? '',
          reps: row['reps'] as int? ?? 0,
          correctAnswer: row['correctAnswer'] as int? ?? 0,
          finalScore: row['finalScore'] as int? ?? 0,
        );
      }).toList();
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<List<DeckCardItem>> getSessionCards(
    String deckId, {
    int limit = 10,
  }) async {
    final allCards = await getAllDeckCards(deckId);
    if (allCards.isEmpty) return const [];

    final shuffled = List<DeckCardItem>.from(allCards)..shuffle(Random());
    return shuffled.take(limit).toList();
  }

  @override
  Future<String> startSession({
    required String deckId,
    required String gameType,
    required int totalQuestions,
  }) async {
    final sessionId =
        'ses_${DateTime.now().millisecondsSinceEpoch}_${randomChar(6)}';
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final stmt = deckDb.prepare('''
        INSERT INTO sessions (
          idSession, gameType, startedAt, completedAt, totalQuestions,
          correctCount, finalScore, duration
        ) VALUES (?, ?, ?, NULL, ?, 0, 0.0, 0);
      ''');
      try {
        stmt.execute([sessionId, gameType, nowMs, totalQuestions]);
      } finally {
        stmt.close();
      }
      return sessionId;
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<void> recordAnswer({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final logId = 'log_${nowMs}_${randomChar(6)}';

    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      deckDb.execute('BEGIN TRANSACTION;');
      try {
        // 1. Insert log row
        final logStmt = deckDb.prepare('''
          INSERT INTO logs (
            idLog, idSession, idCard, questionType, isCorrect, timeSpent, timestamp
          ) VALUES (?, ?, ?, ?, ?, ?, ?);
        ''');
        try {
          logStmt.execute([
            logId,
            sessionId,
            cardId,
            questionType,
            isCorrect ? 1.0 : 0.0,
            timeSpentMs,
            nowMs,
          ]);
        } finally {
          logStmt.close();
        }

        // 2. Update card mastery stats
        final cardRows = deckDb.select(
          'SELECT reps, correctAnswer FROM cards WHERE idCard = ? LIMIT 1;',
          [cardId],
        );
        if (cardRows.isNotEmpty) {
          final currentReps = cardRows.first['reps'] as int? ?? 0;
          final currentCorrect = cardRows.first['correctAnswer'] as int? ?? 0;
          final nextReps = currentReps + 1;
          final nextCorrect = currentCorrect + (isCorrect ? 1 : 0);
          final nextScore = ((nextCorrect * 100) / nextReps).round().clamp(
            0,
            100,
          );

          final updateCardStmt = deckDb.prepare('''
            UPDATE cards
            SET reps = ?, correctAnswer = ?, finalScore = ?, updatedAt = ?
            WHERE idCard = ?;
          ''');
          try {
            updateCardStmt.execute([
              nextReps,
              nextCorrect,
              nextScore,
              nowMs,
              cardId,
            ]);
          } finally {
            updateCardStmt.close();
          }
        }

        deckDb.execute('COMMIT;');
      } catch (_) {
        deckDb.execute('ROLLBACK;');
        rethrow;
      }
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<StudySessionResult> completeSession({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  }) async {
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final durationMs = (nowMs - startedAtMs).clamp(1000, 86400000);
    final totalQuestions = outcomes.length;
    final correctCount = outcomes.where((v) => v).length;
    final wrongCount = totalQuestions - correctCount;
    final finalScore = totalQuestions > 0
        ? (correctCount * 100.0) / totalQuestions
        : 0.0;
    final todayKey = DeckDetailsLocalDataSourceImpl.formatDateKey(now);

    var isFirstSessionTodayOnDeck = false;

    // 1. Update per-deck database (sessions & daily_deck_stats)
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      deckDb.execute('BEGIN TRANSACTION;');
      try {
        final updateSessionStmt = deckDb.prepare('''
          UPDATE sessions
          SET completedAt = ?, totalQuestions = ?, correctCount = ?,
              finalScore = ?, duration = ?
          WHERE idSession = ?;
        ''');
        try {
          updateSessionStmt.execute([
            nowMs,
            totalQuestions,
            correctCount,
            finalScore,
            durationMs,
            sessionId,
          ]);
        } finally {
          updateSessionStmt.close();
        }

        final existingStatRows = deckDb.select(
          '''
          SELECT totalActiveTime, cardsPracticed, correctAnswer
          FROM daily_deck_stats
          WHERE date = ?
          LIMIT 1;
        ''',
          [todayKey],
        );

        if (existingStatRows.isEmpty) {
          isFirstSessionTodayOnDeck = true;
          final insertStatStmt = deckDb.prepare('''
            INSERT INTO daily_deck_stats (
              date, totalActiveTime, cardsPracticed, correctAnswer, accuracyRate
            ) VALUES (?, ?, ?, ?, ?);
          ''');
          try {
            insertStatStmt.execute([
              todayKey,
              durationMs,
              totalQuestions,
              correctCount,
              finalScore,
            ]);
          } finally {
            insertStatStmt.close();
          }
        } else {
          final prevTime =
              existingStatRows.first['totalActiveTime'] as int? ?? 0;
          final prevPracticed =
              existingStatRows.first['cardsPracticed'] as int? ?? 0;
          final prevCorrect =
              existingStatRows.first['correctAnswer'] as int? ?? 0;

          final newTime = prevTime + durationMs;
          final newPracticed = prevPracticed + totalQuestions;
          final newCorrect = prevCorrect + correctCount;
          final newAcc = newPracticed > 0
              ? (newCorrect * 100.0) / newPracticed
              : 0.0;

          final updateStatStmt = deckDb.prepare('''
            UPDATE daily_deck_stats
            SET totalActiveTime = ?, cardsPracticed = ?, correctAnswer = ?, accuracyRate = ?
            WHERE date = ?;
          ''');
          try {
            updateStatStmt.execute([
              newTime,
              newPracticed,
              newCorrect,
              newAcc,
              todayKey,
            ]);
          } finally {
            updateStatStmt.close();
          }
        }

        deckDb.execute('COMMIT;');
      } catch (_) {
        deckDb.execute('ROLLBACK;');
        rethrow;
      }
    } finally {
      deckDb.close();
    }

    // 2. Update main database (decks & global_daily_activity)
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      mainDb.execute('BEGIN TRANSACTION;');
      try {
        final updateDeckStmt = mainDb.prepare('''
          UPDATE decks
          SET activeTime = activeTime + ?, lastStudiedAt = ?, updatedAt = ?
          WHERE id = ?;
        ''');
        try {
          updateDeckStmt.execute([durationMs, nowMs, nowMs, deckId]);
        } finally {
          updateDeckStmt.close();
        }

        final globalRows = mainDb.select(
          '''
          SELECT activeTime, cardsReviewed, decksStudied
          FROM global_daily_activity
          WHERE date = ?
          LIMIT 1;
        ''',
          [todayKey],
        );

        if (globalRows.isEmpty) {
          final insertGlobalStmt = mainDb.prepare('''
            INSERT INTO global_daily_activity (
              date, activeTime, cardsReviewed, decksStudied
            ) VALUES (?, ?, ?, 1);
          ''');
          try {
            insertGlobalStmt.execute([todayKey, durationMs, totalQuestions]);
          } finally {
            insertGlobalStmt.close();
          }
        } else {
          final prevActive = globalRows.first['activeTime'] as int? ?? 0;
          final prevCards = globalRows.first['cardsReviewed'] as int? ?? 0;
          final prevDecks = globalRows.first['decksStudied'] as int? ?? 0;

          final updateGlobalStmt = mainDb.prepare('''
            UPDATE global_daily_activity
            SET activeTime = ?, cardsReviewed = ?, decksStudied = ?
            WHERE date = ?;
          ''');
          try {
            updateGlobalStmt.execute([
              prevActive + durationMs,
              prevCards + totalQuestions,
              prevDecks + (isFirstSessionTodayOnDeck ? 1 : 0),
              todayKey,
            ]);
          } finally {
            updateGlobalStmt.close();
          }
        }

        mainDb.execute('COMMIT;');
      } catch (_) {
        mainDb.execute('ROLLBACK;');
        rethrow;
      }
    } finally {
      mainDb.close();
    }

    return StudySessionResult(
      sessionId: sessionId,
      deckId: deckId,
      gameType: gameType,
      totalQuestions: totalQuestions,
      correctCount: correctCount,
      wrongCount: wrongCount,
      durationMs: durationMs,
      outcomes: outcomes,
    );
  }
}
