import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Database loader utility for per-deck databases (`decks/deck_<uuid>.sqlite`).
///
/// Responsible for opening isolated SQLite database files per deck and
/// creating the required tables (`cards`, `sessions`, `logs`, and `daily_deck_stats`)
/// as defined in the storage specifications.
class DeckDbLoader {
  /// Subdirectory under the app storage root where isolated deck databases reside.
  static const String decksSubdirectory = 'decks';

  final Future<Directory> Function()? _storageDirProvider;

  /// Creates a [DeckDbLoader] instance with an optional custom [storageDirProvider].
  const DeckDbLoader([this._storageDirProvider]);

  /// Resolves the storage root directory for application databases.
  Future<Directory> getStorageDirectory() async {
    return _storageDirProvider != null
        ? await _storageDirProvider()
        : await getApplicationDocumentsDirectory();
  }

  /// Resolves the directory housing deck databases, creating it if necessary.
  Future<Directory> getDecksDirectory({Directory? overrideDirectory}) async {
    final rootDir = overrideDirectory ?? await getStorageDirectory();
    final decksDir = Directory('${rootDir.path}/$decksSubdirectory');
    if (!await decksDir.exists()) {
      await decksDir.create(recursive: true);
    }
    return decksDir;
  }

  /// Generates the database filename for a given [deckId].
  static String formatDatabaseFileName(String deckId) => 'deck_$deckId.sqlite';

  /// Opens the SQLite database connection for [deckId] and initializes its schema.
  Future<Database> openDeckDatabase(
    String deckId, {
    Directory? overrideDirectory,
  }) async {
    final decksDir = await getDecksDirectory(
      overrideDirectory: overrideDirectory,
    );
    final dbPath = '${decksDir.path}/${formatDatabaseFileName(deckId)}';
    final db = sqlite3.open(dbPath);
    initializeSchema(db);
    return db;
  }

  /// Initializes the SQLite schema for the deck database tables.
  static void initializeSchema(Database db) {
    db.execute('PRAGMA foreign_keys = ON;');

    // Table: cards
    db.execute('''
      CREATE TABLE IF NOT EXISTS cards (
        idCard TEXT PRIMARY KEY,
        defaultLanguage TEXT NOT NULL,
        translation TEXT NOT NULL,
        phoneticLang TEXT,
        audioPath TEXT,
        additionalContext TEXT,
        reps INTEGER NOT NULL DEFAULT 0,
        correctAnswer INTEGER NOT NULL DEFAULT 0,
        finalScore INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      );
    ''');

    // Table: sessions
    db.execute('''
      CREATE TABLE IF NOT EXISTS sessions (
        idSession TEXT PRIMARY KEY,
        gameType TEXT NOT NULL,
        startedAt INTEGER NOT NULL,
        completedAt INTEGER,
        totalQuestions INTEGER NOT NULL DEFAULT 10,
        correctCount INTEGER NOT NULL DEFAULT 0,
        finalScore REAL NOT NULL DEFAULT 0.0,
        duration INTEGER NOT NULL DEFAULT 0
      );
    ''');

    // Table: logs
    db.execute('''
      CREATE TABLE IF NOT EXISTS logs (
        idLog TEXT PRIMARY KEY,
        idSession TEXT NOT NULL,
        idCard TEXT NOT NULL,
        questionType TEXT NOT NULL,
        isCorrect REAL NOT NULL,
        timeSpent INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (idSession) REFERENCES sessions(idSession) ON DELETE CASCADE,
        FOREIGN KEY (idCard) REFERENCES cards(idCard) ON DELETE CASCADE
      );
    ''');

    // Table: daily_deck_stats
    db.execute('''
      CREATE TABLE IF NOT EXISTS daily_deck_stats (
        date TEXT PRIMARY KEY,
        totalActiveTime INTEGER NOT NULL DEFAULT 0,
        cardsPracticed INTEGER NOT NULL DEFAULT 0,
        correctAnswer INTEGER NOT NULL DEFAULT 0,
        accuracyRate REAL NOT NULL DEFAULT 0.0
      );
    ''');
  }
}
