import 'dart:io';
import 'dart:math';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/deck_details/data/datasources/deck_details_local_data_source.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import '../../domain/entities/multiplayer_quiz_question.dart';

/// Contract for multiplayer SQLite data operations.
abstract class MultiplayerLocalDataSource {
  /// Loads all decks available in `basa.sqlite`.
  Future<List<DeckItem>> getAllDecks();

  /// Loads up to 10 generated quiz questions from [deckId].
  Future<List<MultiplayerQuizQuestion>> generateQuestionsForDeck(String deckId);

  /// Saves a completed multiplayer session to SQLite and updates analytics.
  Future<void> saveCompletedSession({
    required String deckId,
    required String sessionId,
    required int startedAtMs,
    required int durationMs,
    required int totalQuestions,
    required int correctCount,
    required double finalScore,
    required List<bool?> outcomes,
  });

  /// Loads past multiplayer sessions across all decks.
  Future<List<Map<String, dynamic>>> getMultiplayerHistory();
}

/// SQLite implementation of [MultiplayerLocalDataSource].
class MultiplayerLocalDataSourceImpl implements MultiplayerLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;
  final Random _random;

  MultiplayerLocalDataSourceImpl({
    this._mainDbLoader = const MainDbLoader(),
    this._deckDbLoader = const DeckDbLoader(),
    this._overrideStorageDirectory,
    Random? random,
  }) : _random = random ?? Random();

  static const List<String> _fallbackDistractors = [
    'Halo Selamat Siang',
    'Terima kasih banyak',
    'Selamat tinggal',
    'Sampai jumpa besok',
    'Selamat pagi',
    'Permisi sebentar',
  ];

  @override
  Future<List<DeckItem>> getAllDecks() async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = mainDb.select('''
        SELECT id, name, language, difficulty, description,
               activeTime, lastStudiedAt, createdAt, updatedAt
        FROM decks
        ORDER BY updatedAt DESC, id ASC;
      ''');

      return rows.map((row) {
        return DeckItem(
          id: row['id'] as String,
          name: row['name'] as String,
          language: row['language'] as String,
          difficulty: row['difficulty'] as String,
          description: row['description'] as String?,
          activeTime: row['activeTime'] as int? ?? 0,
          lastStudiedAt: row['lastStudiedAt'] as int?,
          createdAt: row['createdAt'] as int,
          updatedAt: row['updatedAt'] as int,
        );
      }).toList();
    } finally {
      mainDb.close();
    }
  }

  @override
  Future<List<MultiplayerQuizQuestion>> generateQuestionsForDeck(
    String deckId,
  ) async {
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = deckDb.select('''
        SELECT idCard, defaultLanguage, translation, phoneticLang, additionalContext
        FROM cards
        ORDER BY idCard ASC;
      ''');

      if (rows.isEmpty) return const [];

      final allCards = rows
          .map(
            (r) => {
              'idCard': r['idCard'] as String,
              'defaultLanguage': (r['defaultLanguage'] as String? ?? '').trim(),
              'translation': (r['translation'] as String? ?? '').trim(),
            },
          )
          .where((c) => (c['defaultLanguage'] as String).isNotEmpty)
          .toList();

      final selectedCards = List<Map<String, String>>.from(allCards)
        ..shuffle(_random);
      final questionsToTake = selectedCards.take(10).toList();

      final questions = <MultiplayerQuizQuestion>[];
      for (final target in questionsToTake) {
        final targetWord = target['defaultLanguage']!;
        final prompt = target['translation']!.isNotEmpty
            ? target['translation']!
            : targetWord;

        // Build 3 distractors
        final candidatePool =
            allCards
                .map((c) => c['defaultLanguage']!)
                .where((w) => w.toLowerCase() != targetWord.toLowerCase())
                .toSet()
                .toList()
              ..shuffle(_random);

        final distractors = <String>[];
        for (final c in candidatePool) {
          if (distractors.length >= 3) break;
          distractors.add(c);
        }

        // Fill with fallback phrases if card count is small
        if (distractors.length < 3) {
          final fallbacks = List<String>.from(_fallbackDistractors)
            ..shuffle(_random);
          for (final f in fallbacks) {
            if (distractors.length >= 3) break;
            if (f.toLowerCase() != targetWord.toLowerCase() &&
                !distractors.contains(f)) {
              distractors.add(f);
            }
          }
        }

        final options = <String>[targetWord, ...distractors]..shuffle(_random);

        questions.add(
          MultiplayerQuizQuestion(
            cardId: target['idCard']!,
            prompt: prompt,
            targetWord: targetWord,
            options: options,
            correctAnswer: targetWord,
          ),
        );
      }

      return questions;
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<void> saveCompletedSession({
    required String deckId,
    required String sessionId,
    required int startedAtMs,
    required int durationMs,
    required int totalQuestions,
    required int correctCount,
    required double finalScore,
    required List<bool?> outcomes,
  }) async {
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final todayKey = DeckDetailsLocalDataSourceImpl.formatDateKey(now);

    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      deckDb.execute('BEGIN TRANSACTION;');
      try {
        final insertSessionStmt = deckDb.prepare('''
          INSERT INTO sessions (
            idSession, gameType, startedAt, completedAt, totalQuestions,
            correctCount, finalScore, duration
          ) VALUES (?, 'multiplayer', ?, ?, ?, ?, ?, ?);
        ''');
        try {
          insertSessionStmt.execute([
            sessionId,
            startedAtMs,
            nowMs,
            totalQuestions,
            correctCount,
            finalScore,
            durationMs,
          ]);
        } finally {
          insertSessionStmt.close();
        }

        // Update daily stats
        final existingStatRows = deckDb.select(
          'SELECT totalActiveTime, cardsPracticed, correctAnswer FROM daily_deck_stats WHERE date = ? LIMIT 1;',
          [todayKey],
        );

        if (existingStatRows.isEmpty) {
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
              prevTime + durationMs,
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

    // Update main database
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
          'SELECT activeTime, cardsReviewed, decksStudied FROM global_daily_activity WHERE date = ? LIMIT 1;',
          [todayKey],
        );

        if (globalRows.isEmpty) {
          final insertGlobalStmt = mainDb.prepare('''
            INSERT INTO global_daily_activity (date, activeTime, cardsReviewed, decksStudied)
            VALUES (?, ?, ?, 1);
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
              prevDecks,
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
  }

  @override
  Future<List<Map<String, dynamic>>> getMultiplayerHistory() async {
    final decks = await getAllDecks();
    final allSessions = <Map<String, dynamic>>[];

    for (final deck in decks) {
      try {
        final deckDb = await _deckDbLoader.openDeckDatabase(
          deck.id,
          overrideDirectory: _overrideStorageDirectory,
        );
        try {
          final rows = deckDb.select('''
            SELECT idSession, gameType, startedAt, completedAt, totalQuestions,
                   correctCount, finalScore, duration
            FROM sessions
            WHERE gameType = 'multiplayer'
            ORDER BY startedAt DESC;
          ''');

          for (final row in rows) {
            allSessions.add({
              'deckId': deck.id,
              'deckTitle': deck.name,
              'idSession': row['idSession'],
              'startedAt': row['startedAt'],
              'completedAt': row['completedAt'],
              'totalQuestions': row['totalQuestions'],
              'correctCount': row['correctCount'],
              'finalScore': row['finalScore'],
              'duration': row['duration'],
            });
          }
        } finally {
          deckDb.close();
        }
      } catch (_) {
        // Skip inaccessible deck DB
      }
    }

    allSessions.sort((a, b) {
      final aStart = a['startedAt'] as int? ?? 0;
      final bStart = b['startedAt'] as int? ?? 0;
      return bStart.compareTo(aStart);
    });

    return allSessions;
  }
}
