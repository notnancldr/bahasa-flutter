import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late DataStorageLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('data_storage_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    dataSource = DataStorageLocalDataSourceImpl(
      appDocsDirProvider: () async => tempDir,
      mainDbLoader: mainDbLoader,
      deckDbLoader: deckDbLoader,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('DataStorageLocalDataSourceImpl.deleteAppData', () {
    test(
      'deletes basa.sqlite, wal/journal files, and decks directory',
      () async {
        // 1. Initialize databases using loaders
        final mainDb = await mainDbLoader.openDatabase();
        mainDb.close();

        const deckId = 'test-deck-uuid-1';
        final deckDb = await deckDbLoader.openDeckDatabase(deckId);
        deckDb.close();

        // Create dummy extra files to simulate WAL or journal files
        final walFile = File(
          '${tempDir.path}/${MainDbLoader.databaseFileName}-wal',
        );
        await walFile.writeAsString('dummy wal');

        final journalFile = File(
          '${tempDir.path}/${MainDbLoader.databaseFileName}-journal',
        );
        await journalFile.writeAsString('dummy journal');

        final mainDbFile = File(
          '${tempDir.path}/${MainDbLoader.databaseFileName}',
        );
        final decksDir = Directory(
          '${tempDir.path}/${DeckDbLoader.decksSubdirectory}',
        );
        final deckDbFile = File(
          '${decksDir.path}/${DeckDbLoader.formatDatabaseFileName(deckId)}',
        );

        // Verify files exist before deletion
        expect(await mainDbFile.exists(), isTrue);
        expect(await walFile.exists(), isTrue);
        expect(await journalFile.exists(), isTrue);
        expect(await decksDir.exists(), isTrue);
        expect(await deckDbFile.exists(), isTrue);

        // 2. Execute deleteAppData
        await dataSource.deleteAppData();

        // 3. Verify database files and directories are deleted
        expect(await mainDbFile.exists(), isFalse);
        expect(await walFile.exists(), isFalse);
        expect(await journalFile.exists(), isFalse);
        expect(await decksDir.exists(), isFalse);
        expect(await deckDbFile.exists(), isFalse);
      },
    );

    test('completes gracefully when files do not exist', () async {
      final mainDbFile = File(
        '${tempDir.path}/${MainDbLoader.databaseFileName}',
      );
      final decksDir = Directory(
        '${tempDir.path}/${DeckDbLoader.decksSubdirectory}',
      );

      expect(await mainDbFile.exists(), isFalse);
      expect(await decksDir.exists(), isFalse);

      await expectLater(dataSource.deleteAppData(), completes);
    });
  });
}
