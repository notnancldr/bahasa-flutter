import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/deck_details/data/datasources/deck_details_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late DeckDetailsLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('deck_details_ds_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    dataSource = DeckDetailsLocalDataSourceImpl(
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

  test('getDeckDetails and getDeckProgress compute streak, accuracy, and top 3 weakest cards', () async {
    const deckId = 'deck_ja_1';
    final now = DateTime(2026, 10, 16, 12, 0);
    final todayKey = DeckDetailsLocalDataSourceImpl.formatDateKey(now);
    final yesterdayKey = DeckDetailsLocalDataSourceImpl.formatDateKey(
      now.subtract(const Duration(days: 1)),
    );

    final mainDb = await mainDbLoader.openDatabase(overrideDirectory: tempDir);
    try {
      mainDb.execute(
        '''
          INSERT INTO decks (
            id, name, language, difficulty, description, activeTime,
            lastStudiedAt, createdAt, updatedAt
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        ''',
        [
          deckId,
          'Kosakata Bahasa Jepang',
          'ja',
          'intermediate',
          'Fokus sapaan harian',
          180000,
          now.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
        ],
      );
    } finally {
      mainDb.close();
    }

    final deckDb = await deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: tempDir,
    );
    try {
      // Insert 4 cards with varying accuracy
      final cards = [
        [
          'c1',
          'Halo',
          'Konnichiwa',
          '/kon.ni.tɕi.wa/',
          'Sapaan siang',
          5,
          1,
          20,
        ],
        [
          'c2',
          'Terima kasih',
          'Arigatou',
          '/a.ɾi.ɡa.toː/',
          'Ungkapan syukur',
          5,
          2,
          40,
        ],
        ['c3', 'Selamat pagi', 'Ohayou', '/o.ha.joː/', 'Sapaan pagi', 5, 3, 60],
        [
          'c4',
          'Selamat malam',
          'Konbanwa',
          '/kom.baɰ̃.wa/',
          'Sapaan malam',
          5,
          5,
          100,
        ],
      ];
      for (final c in cards) {
        deckDb.execute(
          '''
            INSERT INTO cards (
              idCard, defaultLanguage, translation, phoneticLang,
              additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
          ''',
          [...c, now.millisecondsSinceEpoch, now.millisecondsSinceEpoch],
        );
      }

      // Insert 2 consecutive days into daily_deck_stats
      deckDb.execute(
        '''
          INSERT INTO daily_deck_stats (
            date, totalActiveTime, cardsPracticed, correctAnswer, accuracyRate
          ) VALUES (?, ?, ?, ?, ?), (?, ?, ?, ?, ?);
        ''',
        [todayKey, 120000, 10, 8, 80.0, yesterdayKey, 60000, 10, 6, 60.0],
      );
    } finally {
      deckDb.close();
    }

    final details = await dataSource.getDeckDetails(deckId);
    expect(details.deck.name, equals('Kosakata Bahasa Jepang'));
    expect(details.cards.length, equals(4));
    expect(details.accuracyPercent, equals(70));

    final progress = await dataSource.getDeckProgress(
      deckId,
      referenceDate: now,
    );
    expect(progress.streakCount, equals(2));
    expect(progress.overallAccuracyPercent, equals(70));
    expect(progress.thisMonthAccuracyPercent, equals(70));
    expect(progress.thisMonthActiveMinutes, equals(3));
    expect(progress.overallWeakestCards.length, equals(3));
    expect(
      progress.overallWeakestCards.first.card.translation,
      equals('Konnichiwa'),
    );
    expect(progress.overallWeakestCards.first.wrongCount, equals(4));
  });
}
