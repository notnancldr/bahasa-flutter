import 'dart:io';

import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/data/datasources/deck_local_data_source.dart';
import 'package:bahasa/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProfileLocalDataSource implements ProfileLocalDataSource {
  final String username;

  const _FakeProfileLocalDataSource(this.username);

  @override
  Future<UserProfileModel> getProfile() async {
    return UserProfileModel(username: username, defaultLanguage: 'id');
  }

  @override
  Future<UserProfileModel> saveProfile(UserProfileModel profile) async =>
      profile;

  @override
  Future<String?> pickProfilePhoto() async => null;

  @override
  Future<bool> hasProfile() async => true;

  @override
  Future<void> clearProfile() async {}
}

void main() {
  late Directory tempDir;
  late MainDbLoader mainDbLoader;
  late DeckDbLoader deckDbLoader;
  late DeckLocalDataSourceImpl localDataSource;
  late DeckRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('deck_repo_test_');
    mainDbLoader = MainDbLoader(() async => tempDir);
    deckDbLoader = DeckDbLoader(() async => tempDir);
    localDataSource = DeckLocalDataSourceImpl(
      mainDbLoader: mainDbLoader,
      deckDbLoader: deckDbLoader,
      overrideStorageDirectory: tempDir,
    );
    repository = DeckRepositoryImpl(
      localDataSource: localDataSource,
      profileDataSource: const _FakeProfileLocalDataSource('Rizky_23'),
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<void> seedDeck({
    required String id,
    required String name,
    String language = 'ja',
    int updatedAt = 1000,
    int? lastStudiedAt,
  }) async {
    final mainDb = await mainDbLoader.openDatabase(overrideDirectory: tempDir);
    try {
      mainDb.execute(
        '''
        INSERT INTO decks (
          id, name, language, difficulty, description, activeTime, lastStudiedAt, createdAt, updatedAt
        ) VALUES (?, ?, ?, 'beginner', 'desc', 0, ?, ?, ?);
        ''',
        [id, name, language, lastStudiedAt, updatedAt, updatedAt],
      );
    } finally {
      mainDb.close();
    }

    final deckDb = await deckDbLoader.openDeckDatabase(
      id,
      overrideDirectory: tempDir,
    );
    deckDb.close();
  }

  test(
    'getDecks returns decks ordered by COALESCE(lastStudiedAt, updatedAt) DESC',
    () async {
      await seedDeck(id: 'd1', name: 'Deck 1', updatedAt: 1000);
      await seedDeck(
        id: 'd2',
        name: 'Deck 2',
        updatedAt: 2000,
        lastStudiedAt: 5000,
      );
      await seedDeck(id: 'd3', name: 'Deck 3', updatedAt: 3000);

      final decks = await repository.getDecks();

      expect(decks.map((d) => d.id).toList(), ['d2', 'd3', 'd1']);
    },
  );

  test(
    'deleteDecks throws UsernameMismatchFailure when username does not match',
    () async {
      await seedDeck(id: 'd1', name: 'Kosakata Bahasa Jepang');

      expect(
        () => repository.deleteDecks(
          deckIds: ['d1'],
          verificationUsername: 'WrongUser',
        ),
        throwsA(isA<UsernameMismatchFailure>()),
      );

      final remaining = await repository.getDecks();
      expect(remaining, hasLength(1));
    },
  );

  test('deleteDecks deletes rows from basa.sqlite and removes deck_<id>.sqlite files on matching username', () async {
    await seedDeck(id: 'd1', name: 'Deck 1');
    await seedDeck(id: 'd2', name: 'Deck 2');

    final decksDir = await deckDbLoader.getDecksDirectory(
      overrideDirectory: tempDir,
    );
    final d1File = File(
      '${decksDir.path}/${DeckDbLoader.formatDatabaseFileName('d1')}',
    );
    final d2File = File(
      '${decksDir.path}/${DeckDbLoader.formatDatabaseFileName('d2')}',
    );

    expect(await d1File.exists(), isTrue);
    expect(await d2File.exists(), isTrue);

    await repository.deleteDecks(
      deckIds: ['d1'],
      verificationUsername: 'Rizky_23',
    );

    final remaining = await repository.getDecks();
    expect(remaining.map((d) => d.id).toList(), ['d2']);
    expect(await d1File.exists(), isFalse);
    expect(await d2File.exists(), isTrue);
  });
}
