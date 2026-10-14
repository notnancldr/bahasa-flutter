import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Database loader utility for the main application database (`basa.sqlite`).
///
/// Responsible for opening the SQLite connection and ensuring the initial
/// schema (`decks` and `global_daily_activity`) is created as defined in
/// the storage specifications.
class MainDbLoader {
  /// File name of the main database.
  static const String databaseFileName = 'basa.sqlite';

  final Future<Directory> Function()? _storageDirProvider;

  /// Creates a [MainDbLoader] instance with an optional custom [storageDirProvider].
  const MainDbLoader([this._storageDirProvider]);

  /// Resolves the storage root directory for application databases.
  Future<Directory> getStorageDirectory() async {
    return _storageDirProvider != null
        ? await _storageDirProvider()
        : await getApplicationDocumentsDirectory();
  }

  /// Opens the main database connection and creates required tables if absent.
  Future<Database> openDatabase({Directory? overrideDirectory}) async {
    final rootDir = overrideDirectory ?? await getStorageDirectory();
    if (!await rootDir.exists()) {
      await rootDir.create(recursive: true);
    }

    final dbPath = '${rootDir.path}/$databaseFileName';
    final db = sqlite3.open(dbPath);
    initializeSchema(db);
    return db;
  }

  /// Initializes the SQLite schema for the main database tables.
  static void initializeSchema(Database db) {
    db.execute('PRAGMA foreign_keys = ON;');

    // Table: decks
    db.execute('''
      CREATE TABLE IF NOT EXISTS decks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        language TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        description TEXT,
        rolePlay TEXT,
        explanationRolePlay TEXT,
        activeTime INTEGER NOT NULL DEFAULT 0,
        lastStudiedAt INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      );
    ''');

    // Table: global_daily_activity
    db.execute('''
      CREATE TABLE IF NOT EXISTS global_daily_activity (
        date TEXT PRIMARY KEY,
        activeTime INTEGER NOT NULL DEFAULT 0,
        cardsReviewed INTEGER NOT NULL DEFAULT 0,
        decksStudied INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }
}
