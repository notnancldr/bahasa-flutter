import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';

import '../../domain/entities/deck_history_card_log.dart';
import '../../domain/entities/deck_history_item.dart';

/// Data source interface for querying deck history and session card logs from SQLite.
abstract class DeckHistoryLocalDataSource {
  /// Queries completed study sessions within `[startEpochMs, endEpochMs]`.
  ///
  /// If [deckId] is specified, only that deck is queried.
  /// If [deckId] is null, queries across all decks in `basa.sqlite`.
  Future<List<DeckHistoryItem>> getSessionsForRange({
    String? deckId,
    required int startEpochMs,
    required int endEpochMs,
  });

  /// Queries card-by-card question logs for [sessionId] in [deckId].
  Future<List<DeckHistoryCardLog>> getSessionCardLogs({
    required String deckId,
    required String sessionId,
  });
}

/// SQLite implementation of [DeckHistoryLocalDataSource].
class DeckHistoryLocalDataSourceImpl implements DeckHistoryLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  /// Creates a [DeckHistoryLocalDataSourceImpl].
  const DeckHistoryLocalDataSourceImpl({
    this._mainDbLoader = const MainDbLoader(),
    this._deckDbLoader = const DeckDbLoader(),
    this._overrideStorageDirectory,
  });

  @override
  Future<List<DeckHistoryItem>> getSessionsForRange({
    String? deckId,
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    if (deckId != null && deckId.isNotEmpty) {
      return _getSessionsForSingleDeck(
        deckId: deckId,
        startEpochMs: startEpochMs,
        endEpochMs: endEpochMs,
      );
    } else {
      return _getSessionsForAllDecks(
        startEpochMs: startEpochMs,
        endEpochMs: endEpochMs,
      );
    }
  }

  Future<List<DeckHistoryItem>> _getSessionsForSingleDeck({
    required String deckId,
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final deckName = await _loadDeckName(deckId);
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = deckDb.select(
        '''
        SELECT idSession, gameType, startedAt, completedAt, totalQuestions,
               correctCount, finalScore, duration
        FROM sessions
        WHERE completedAt IS NOT NULL
          AND completedAt >= ?
          AND completedAt <= ?
        ORDER BY completedAt DESC;
      ''',
        [startEpochMs, endEpochMs],
      );

      return rows.map((row) {
        return DeckHistoryItem(
          sessionId: row['idSession'] as String,
          deckId: deckId,
          deckName: deckName,
          gameType: row['gameType'] as String? ?? 'quiz',
          startedAt: DateTime.fromMillisecondsSinceEpoch(
            row['startedAt'] as int? ?? startEpochMs,
          ),
          completedAt: DateTime.fromMillisecondsSinceEpoch(
            row['completedAt'] as int? ?? endEpochMs,
          ),
          totalQuestions: row['totalQuestions'] as int? ?? 0,
          correctCount: row['correctCount'] as int? ?? 0,
          finalScore: (row['finalScore'] as num?)?.toDouble() ?? 0.0,
          durationMs: row['duration'] as int? ?? 0,
        );
      }).toList();
    } finally {
      deckDb.close();
    }
  }

  Future<List<DeckHistoryItem>> _getSessionsForAllDecks({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    final deckRows = <Map<String, dynamic>>[];
    try {
      final rows = mainDb.select(
        'SELECT id, name FROM decks ORDER BY name ASC;',
      );
      for (final r in rows) {
        deckRows.add({'id': r['id'] as String, 'name': r['name'] as String});
      }
    } finally {
      mainDb.close();
    }

    final allSessions = <DeckHistoryItem>[];

    for (final deck in deckRows) {
      final dId = deck['id'] as String;
      final dName = deck['name'] as String;

      try {
        final deckDb = await _deckDbLoader.openDeckDatabase(
          dId,
          overrideDirectory: _overrideStorageDirectory,
        );

        try {
          final rows = deckDb.select(
            '''
            SELECT idSession, gameType, startedAt, completedAt, totalQuestions,
                   correctCount, finalScore, duration
            FROM sessions
            WHERE completedAt IS NOT NULL
              AND completedAt >= ?
              AND completedAt <= ?
            ORDER BY completedAt DESC;
          ''',
            [startEpochMs, endEpochMs],
          );

          for (final row in rows) {
            allSessions.add(
              DeckHistoryItem(
                sessionId: row['idSession'] as String,
                deckId: dId,
                deckName: dName,
                gameType: row['gameType'] as String? ?? 'quiz',
                startedAt: DateTime.fromMillisecondsSinceEpoch(
                  row['startedAt'] as int? ?? startEpochMs,
                ),
                completedAt: DateTime.fromMillisecondsSinceEpoch(
                  row['completedAt'] as int? ?? endEpochMs,
                ),
                totalQuestions: row['totalQuestions'] as int? ?? 0,
                correctCount: row['correctCount'] as int? ?? 0,
                finalScore: (row['finalScore'] as num?)?.toDouble() ?? 0.0,
                durationMs: row['duration'] as int? ?? 0,
              ),
            );
          }
        } finally {
          deckDb.close();
        }
      } catch (_) {
        // If a deck database file is corrupt or not found, continue with other decks
      }
    }

    allSessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return allSessions;
  }

  Future<String> _loadDeckName(String deckId) async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = mainDb.select(
        'SELECT name FROM decks WHERE id = ? LIMIT 1;',
        [deckId],
      );
      if (rows.isNotEmpty) {
        return rows.first['name'] as String? ?? deckId;
      }
      return deckId;
    } finally {
      mainDb.close();
    }
  }

  @override
  Future<List<DeckHistoryCardLog>> getSessionCardLogs({
    required String deckId,
    required String sessionId,
  }) async {
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = deckDb.select(
        '''
        SELECT l.idLog, l.idCard, l.isCorrect, l.timeSpent, l.timestamp,
               c.defaultLanguage, c.translation, c.phoneticLang
        FROM logs l
        LEFT JOIN cards c ON l.idCard = c.idCard
        WHERE l.idSession = ?
        ORDER BY l.timestamp ASC;
      ''',
        [sessionId],
      );

      return rows.map((row) {
        final isCorrectNum = (row['isCorrect'] as num?)?.toDouble() ?? 0.0;
        return DeckHistoryCardLog(
          logId: row['idLog'] as String,
          cardId: row['idCard'] as String,
          defaultLanguage: row['defaultLanguage'] as String? ?? '',
          translation: row['translation'] as String? ?? '',
          phoneticLang: row['phoneticLang'] as String?,
          isCorrect: isCorrectNum >= 1.0,
          timeSpentMs: row['timeSpent'] as int? ?? 0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            row['timestamp'] as int? ?? 0,
          ),
        );
      }).toList();
    } finally {
      deckDb.close();
    }
  }
}
