import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/import_deck/data/datasources/euy_file_data_source.dart';
import 'package:bahasa/features/decks/import_deck/data/repositories/import_deck_repository_impl.dart';
import 'package:bahasa/features/decks/import_deck/domain/entities/euy_card.dart';
import 'package:bahasa/features/decks/import_deck/domain/entities/euy_deck.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late ImportDeckRepositoryImpl repository;
  late MainDbLoader mainLoader;
  late DeckDbLoader deckLoader;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('import_repo_test_');
    mainLoader = MainDbLoader(() async => tempDir);
    deckLoader = DeckDbLoader(() async => tempDir);
    repository = ImportDeckRepositoryImpl(
      mainDbLoader: mainLoader,
      deckDbLoader: deckLoader,
      overrideStorageDirectory: tempDir,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'importDeck writes deck to basa.sqlite and cards to deck_<uuid>.sqlite',
    () async {
      const deck = EuyDeck(
        id: 'deck-xyz-999',
        name: 'Vocabulary Test',
        language: 'ja',
        difficulty: 'expert',
        rolePlay: 'Sensei',
        explanationRolePlay: 'Formal notes',
        listCards: [
          EuyCard(
            idCard: 'card-1',
            defaultLanguage: 'Kucing',
            translation: 'Neko',
            phoneticLang: 'ねこ',
            additionalContext: 'Hewan berkaki empat',
            reps: 0,
            correctAnswer: 0,
            finalScore: 0,
          ),
        ],
      );

      await repository.importDeck(deck);

      // Verify basa.sqlite
      final mainDb = await mainLoader.openDatabase(overrideDirectory: tempDir);
      addTearDown(mainDb.close);
      final deckRows = mainDb.select(
        "SELECT * FROM decks WHERE id = 'deck-xyz-999';",
      );
      expect(deckRows.length, equals(1));
      expect(deckRows.first['name'], equals('Vocabulary Test'));
      expect(deckRows.first['difficulty'], equals('expert'));

      // Verify deck_deck-xyz-999.sqlite
      final deckDb = await deckLoader.openDeckDatabase(
        'deck-xyz-999',
        overrideDirectory: tempDir,
      );
      addTearDown(deckDb.close);
      final cardRows = deckDb.select(
        "SELECT * FROM cards WHERE idCard = 'card-1';",
      );
      expect(cardRows.length, equals(1));
      expect(cardRows.first['translation'], equals('Neko'));
    },
  );

  test('pickEuyFile delegates to EuyFileDataSource', () async {
    final customDataSource = EuyFileDataSourceImpl(
      () async => '/fake/path/sample.euy',
    );
    final customRepo = ImportDeckRepositoryImpl(
      fileDataSource: customDataSource,
    );
    final picked = await customRepo.pickEuyFile();
    expect(picked, equals('/fake/path/sample.euy'));
  });

  test(
    'getFileProperty returns name and formatted size without full parsing',
    () async {
      final sampleFile = File('${tempDir.path}/my_sample.euy');
      await sampleFile.writeAsString('{"dummy": true}');

      final property = await repository.getFileProperty(sampleFile.path);
      expect(property.path, equals(sampleFile.path));
      expect(property.name, equals('my_sample.euy'));
      expect(property.sizeFormatted, contains('B'));
    },
  );
}
