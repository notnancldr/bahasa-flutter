import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../domain/entities/deck_card_item.dart';
import '../../domain/entities/deck_details_data.dart';
import '../../domain/entities/deck_progress_data.dart';

/// Local SQLite data source contract for Deck Details and Deck Progress.
abstract class DeckDetailsLocalDataSource {
  /// Loads the deck metadata, cards, streak, and overall accuracy for [deckId].
  Future<DeckDetailsData> getDeckDetails(String deckId);

  /// Loads the detailed progress metrics (weekly, monthly, calendar, weakest cards) for [deckId].
  Future<DeckProgressData> getDeckProgress(
    String deckId, {
    DateTime? referenceDate,
  });

  /// Queries the top 3 weakest cards for [deckId] within `[startEpochMs, endEpochMs]`.
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  });
}

/// SQLite implementation of [DeckDetailsLocalDataSource].
class DeckDetailsLocalDataSourceImpl implements DeckDetailsLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  /// Creates a [DeckDetailsLocalDataSourceImpl].
  const DeckDetailsLocalDataSourceImpl({
    this._mainDbLoader = const MainDbLoader(),
    this._deckDbLoader = const DeckDbLoader(),
    this._overrideStorageDirectory,
  });

  @override
  Future<DeckDetailsData> getDeckDetails(String deckId) async {
    final deck = await _loadDeckItem(deckId);
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final cards = _queryCards(deckDb);
      final statsRows = deckDb.select('''
        SELECT date, totalActiveTime, cardsPracticed, correctAnswer, accuracyRate
        FROM daily_deck_stats
        ORDER BY date DESC;
      ''');

      final streakCount = _calculateStreak(statsRows, DateTime.now());
      final accuracyPercent = _calculateOverallAccuracy(statsRows, cards);

      return DeckDetailsData(
        deck: deck,
        cards: cards,
        streakCount: streakCount,
        accuracyPercent: accuracyPercent,
      );
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<DeckProgressData> getDeckProgress(
    String deckId, {
    DateTime? referenceDate,
  }) async {
    final now = referenceDate ?? DateTime.now();
    final deck = await _loadDeckItem(deckId);
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final cards = _queryCards(deckDb);
      final statsRows = deckDb.select('''
        SELECT date, totalActiveTime, cardsPracticed, correctAnswer, accuracyRate
        FROM daily_deck_stats
        ORDER BY date DESC;
      ''');

      final streakCount = _calculateStreak(statsRows, now);
      final overallAccuracyPercent = _calculateOverallAccuracy(
        statsRows,
        cards,
      );

      final dailyStatsByDateKey = <String, DailyStatSummary>{};
      for (final row in statsRows) {
        final dateStr = row['date'] as String?;
        if (dateStr == null) continue;
        final parsed = DateTime.tryParse(dateStr);
        if (parsed == null) continue;
        final normalized = DateTime(parsed.year, parsed.month, parsed.day);
        final key = formatDateKey(normalized);
        dailyStatsByDateKey[key] = DailyStatSummary(
          date: normalized,
          activeTimeMs: row['totalActiveTime'] as int? ?? 0,
          cardsPracticed: row['cardsPracticed'] as int? ?? 0,
          correctAnswer: row['correctAnswer'] as int? ?? 0,
          accuracyRate: (row['accuracyRate'] as num?)?.toDouble() ?? 0.0,
        );
      }

      // Weekly Mon..Sun active booleans for the current week
      final monday = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));
      final weeklyActiveDays = List<bool>.generate(7, (index) {
        final day = monday.add(Duration(days: index));
        final stat = dailyStatsByDateKey[formatDateKey(day)];
        return stat != null &&
            (stat.cardsPracticed > 0 || stat.activeTimeMs > 0);
      });

      // Monthly stats for 1..12 of now.year
      final monthlyStats = List<MonthlyStatPoint>.generate(12, (index) {
        final month = index + 1;
        return _aggregateMonth(dailyStatsByDateKey.values, now.year, month);
      });

      // Current month vs previous month comparisons
      final thisMonthPoint = _aggregateMonth(
        dailyStatsByDateKey.values,
        now.year,
        now.month,
      );
      final prevMonthDate = DateTime(now.year, now.month - 1, 1);
      final lastMonthPoint = _aggregateMonth(
        dailyStatsByDateKey.values,
        prevMonthDate.year,
        prevMonthDate.month,
      );

      final overallWeakestCards = _queryWeakestCardsOverall(deckDb, cards);

      return DeckProgressData(
        deck: deck,
        streakCount: streakCount,
        overallAccuracyPercent: overallAccuracyPercent,
        thisMonthAccuracyPercent: thisMonthPoint.cardsPracticed > 0
            ? thisMonthPoint.accuracyPercent
            : overallAccuracyPercent,
        lastMonthAccuracyPercent: lastMonthPoint.accuracyPercent,
        thisMonthActiveMinutes: thisMonthPoint.activeMinutes,
        lastMonthActiveMinutes: lastMonthPoint.activeMinutes,
        weeklyActiveDays: weeklyActiveDays,
        dailyStatsByDateKey: dailyStatsByDateKey,
        monthlyStats: monthlyStats,
        overallWeakestCards: overallWeakestCards,
        referenceDate: now,
      );
    } finally {
      deckDb.close();
    }
  }

  @override
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final cards = _queryCards(deckDb);
      final cardMap = {for (final c in cards) c.idCard: c};

      final logRows = deckDb.select(
        '''
        SELECT
          idCard,
          COUNT(*) AS totalAttempts,
          SUM(CASE WHEN isCorrect >= 0.5 THEN 1 ELSE 0 END) AS correctAttempts
        FROM logs
        WHERE timestamp >= ? AND timestamp <= ?
        GROUP BY idCard
        HAVING totalAttempts > 0
        ORDER BY (totalAttempts - correctAttempts) DESC,
                 (CAST(correctAttempts AS REAL) / totalAttempts) ASC
        LIMIT 3;
      ''',
        [startEpochMs, endEpochMs],
      );

      if (logRows.isNotEmpty) {
        final results = <WeakCardSummary>[];
        for (final row in logRows) {
          final idCard = row['idCard'] as String?;
          final card = idCard != null ? cardMap[idCard] : null;
          if (card == null) continue;
          final total = row['totalAttempts'] as int? ?? 0;
          final correct = row['correctAttempts'] as int? ?? 0;
          final wrong = (total - correct).clamp(0, total);
          final acc = total > 0
              ? ((correct * 100) / total).round().clamp(0, 100)
              : 0;
          results.add(
            WeakCardSummary(
              card: card,
              wrongCount: wrong,
              accuracyPercent: acc,
            ),
          );
        }
        if (results.isNotEmpty) {
          return results;
        }
      }

      return _queryWeakestCardsOverall(deckDb, cards);
    } finally {
      deckDb.close();
    }
  }

  /// Formats a [DateTime] as `YYYY-MM-DD`.
  static String formatDateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<DeckItem> _loadDeckItem(String deckId) async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = mainDb.select(
        '''
        SELECT id, name, language, difficulty, description, activeTime, lastStudiedAt, createdAt, updatedAt
        FROM decks
        WHERE id = ?
        LIMIT 1;
      ''',
        [deckId],
      );

      if (rows.isEmpty) {
        throw StateError('Deck not found: $deckId');
      }

      final row = rows.first;
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      return DeckItem(
        id: row['id'] as String,
        name: row['name'] as String,
        language: row['language'] as String,
        difficulty: row['difficulty'] as String,
        description: row['description'] as String?,
        activeTime: row['activeTime'] as int? ?? 0,
        lastStudiedAt: row['lastStudiedAt'] as int?,
        createdAt: row['createdAt'] as int? ?? nowMs,
        updatedAt: row['updatedAt'] as int? ?? nowMs,
      );
    } finally {
      mainDb.close();
    }
  }

  List<DeckCardItem> _queryCards(Database deckDb) {
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
  }

  int _calculateStreak(List<Map<String, dynamic>> statsRows, DateTime now) {
    if (statsRows.isEmpty) return 0;

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    var streak = 0;
    DateTime? expectedDate;
    var started = false;

    for (final row in statsRows) {
      final cardsPracticed = row['cardsPracticed'] as int? ?? 0;
      final activeTime = row['totalActiveTime'] as int? ?? 0;
      if (cardsPracticed <= 0 && activeTime <= 0) continue;

      final dateStr = row['date'] as String?;
      if (dateStr == null) continue;
      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) continue;
      final normalized = DateTime(parsed.year, parsed.month, parsed.day);

      if (!started) {
        if (normalized == today) {
          started = true;
          streak++;
          expectedDate = yesterday;
        } else if (normalized == yesterday) {
          started = true;
          streak++;
          expectedDate = yesterday.subtract(const Duration(days: 1));
        } else if (normalized.isBefore(yesterday)) {
          break;
        }
      } else {
        if (expectedDate != null && normalized == expectedDate) {
          streak++;
          expectedDate = expectedDate.subtract(const Duration(days: 1));
        } else if (expectedDate != null && normalized.isBefore(expectedDate)) {
          break;
        }
      }
    }

    return streak;
  }

  int _calculateOverallAccuracy(
    List<Map<String, dynamic>> statsRows,
    List<DeckCardItem> cards,
  ) {
    var totalPracticed = 0;
    var totalCorrect = 0;
    for (final row in statsRows) {
      totalPracticed += row['cardsPracticed'] as int? ?? 0;
      totalCorrect += row['correctAnswer'] as int? ?? 0;
    }

    if (totalPracticed > 0) {
      return ((totalCorrect * 100) / totalPracticed).round().clamp(0, 100);
    }

    var cardReps = 0;
    var cardCorrect = 0;
    for (final card in cards) {
      cardReps += card.reps;
      cardCorrect += card.correctAnswer;
    }

    if (cardReps > 0) {
      return ((cardCorrect * 100) / cardReps).round().clamp(0, 100);
    }

    return 0;
  }

  MonthlyStatPoint _aggregateMonth(
    Iterable<DailyStatSummary> dailyStats,
    int year,
    int month,
  ) {
    var activeTimeMs = 0;
    var cardsPracticed = 0;
    var correctAnswer = 0;

    for (final stat in dailyStats) {
      if (stat.date.year == year && stat.date.month == month) {
        activeTimeMs += stat.activeTimeMs;
        cardsPracticed += stat.cardsPracticed;
        correctAnswer += stat.correctAnswer;
      }
    }

    final accuracyPercent = cardsPracticed > 0
        ? ((correctAnswer * 100) / cardsPracticed).round().clamp(0, 100)
        : 0;

    return MonthlyStatPoint(
      month: month,
      activeTimeMs: activeTimeMs,
      cardsPracticed: cardsPracticed,
      correctAnswer: correctAnswer,
      accuracyPercent: accuracyPercent,
    );
  }

  List<WeakCardSummary> _queryWeakestCardsOverall(
    Database deckDb,
    List<DeckCardItem> cards,
  ) {
    if (cards.isEmpty) return const [];

    final practiced = cards.where((c) => c.reps > 0).toList();
    if (practiced.isNotEmpty) {
      practiced.sort((a, b) {
        final wrongCmp = b.wrongCount.compareTo(a.wrongCount);
        if (wrongCmp != 0) return wrongCmp;
        return a.accuracyPercent.compareTo(b.accuracyPercent);
      });
      return practiced.take(3).map((card) {
        return WeakCardSummary(
          card: card,
          wrongCount: card.wrongCount,
          accuracyPercent: card.accuracyPercent,
        );
      }).toList();
    }

    // Fallback if no cards have been practiced yet: return first 3 cards with 0 stats
    return cards.take(3).map((card) {
      return WeakCardSummary(card: card, wrongCount: 0, accuracyPercent: 0);
    }).toList();
  }
}
