import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';

import '../../domain/entities/deck_item.dart';

/// Local data source contract for reading and deleting decks from SQLite storage.
abstract class DeckLocalDataSource {
  /// Queries all saved decks from `basa.sqlite` ordered by recent study/update time.
  Future<List<DeckItem>> getDecks();

  /// Deletes the specified [deckIds] from `basa.sqlite` and removes their
  /// corresponding `decks/deck_<id>.sqlite` files.
  Future<void> deleteDecks(List<String> deckIds);
}

/// SQLite-backed implementation of [DeckLocalDataSource].
class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  /// Creates a [DeckLocalDataSourceImpl] with optional database loader overrides.
  const DeckLocalDataSourceImpl({
    this._mainDbLoader = const MainDbLoader(),
    this._deckDbLoader = const DeckDbLoader(),
    this._overrideStorageDirectory,
  });

  @override
  Future<List<DeckItem>> getDecks() async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      final rows = mainDb.select('''
        SELECT id, name, language, difficulty, description, activeTime, lastStudiedAt, createdAt, updatedAt
        FROM decks
        ORDER BY COALESCE(lastStudiedAt, updatedAt) DESC;
      ''');

      return rows.map((row) {
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
      }).toList();
    } finally {
      mainDb.close();
    }
  }

  @override
  Future<void> deleteDecks(List<String> deckIds) async {
    if (deckIds.isEmpty) return;

    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      mainDb.execute('BEGIN TRANSACTION;');
      try {
        final stmt = mainDb.prepare('DELETE FROM decks WHERE id = ?;');
        try {
          for (final id in deckIds) {
            stmt.execute([id]);
          }
        } finally {
          stmt.close();
        }
        mainDb.execute('COMMIT;');
      } catch (_) {
        mainDb.execute('ROLLBACK;');
        rethrow;
      }
    } finally {
      mainDb.close();
    }

    // Remove isolated per-deck SQLite database files and sidecars
    final decksDir = await _deckDbLoader.getDecksDirectory(
      overrideDirectory: _overrideStorageDirectory,
    );

    for (final id in deckIds) {
      final baseFilePath =
          '${decksDir.path}/${DeckDbLoader.formatDatabaseFileName(id)}';
      for (final suffix in const ['', '-wal', '-shm', '-journal']) {
        final file = File('$baseFilePath$suffix');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }
}
