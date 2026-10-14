import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late DeckDbLoader loader;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('deck_db_test_');
    loader = DeckDbLoader(() async => tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('DeckDbLoader creates deck_<uuid>.sqlite with cards, sessions, logs, daily_deck_stats tables', () async {
    const deckId = 'test-uuid-1234';
    final db = await loader.openDeckDatabase(deckId);
    addTearDown(db.close);

    final tablesResult = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;",
    );
    final tableNames = tablesResult
        .map((row) => row['name'] as String)
        .toList();

    expect(tableNames, contains('cards'));
    expect(tableNames, contains('sessions'));
    expect(tableNames, contains('logs'));
    expect(tableNames, contains('daily_deck_stats'));

    // Verify insertion into cards table
    db.execute('''
      INSERT INTO cards (idCard, defaultLanguage, translation, phoneticLang, audioPath, additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt)
      VALUES ('c1', 'Selamat', 'Safe', NULL, NULL, 'Catatan', 0, 0, 0, 100, 100);
    ''');

    final cardRow = db.select("SELECT * FROM cards WHERE idCard = 'c1';");
    expect(cardRow.length, equals(1));
    expect(cardRow.first['defaultLanguage'], equals('Selamat'));
  });
}
