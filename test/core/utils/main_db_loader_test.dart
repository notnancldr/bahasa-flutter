import 'dart:io';

import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader loader;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('main_db_test_');
    loader = MainDbLoader(() async => tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('MainDbLoader creates basa.sqlite with decks and global_daily_activity tables', () async {
    final db = await loader.openDatabase();
    addTearDown(db.close);

    final tablesResult = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;",
    );
    final tableNames = tablesResult
        .map((row) => row['name'] as String)
        .toList();

    expect(tableNames, contains('decks'));
    expect(tableNames, contains('global_daily_activity'));

    // Verify insertion into decks table
    db.execute('''
      INSERT INTO decks (id, name, language, difficulty, description, rolePlay, explanationRolePlay, activeTime, lastStudiedAt, createdAt, updatedAt)
      VALUES ('d1', 'Test Deck', 'ja', 'intermediate', 'Desc', 'Role', 'Explanation', 0, NULL, 123456789, 123456789);
    ''');

    final deckRow = db.select("SELECT * FROM decks WHERE id = 'd1';");
    expect(deckRow.length, equals(1));
    expect(deckRow.first['name'], equals('Test Deck'));
    expect(deckRow.first['language'], equals('ja'));
  });
}
