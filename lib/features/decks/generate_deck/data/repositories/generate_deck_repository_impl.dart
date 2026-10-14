import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/core/utils/random_char.dart';

import '../../domain/entities/deck_generation_request.dart';
import '../../domain/entities/generated_deck_result.dart';
import '../../domain/repositories/generate_deck_repository.dart';

/// Implementation of [GenerateDeckRepository] simulating AI generation
/// and committing the generated records into SQLite.
class GenerateDeckRepositoryImpl implements GenerateDeckRepository {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  const GenerateDeckRepositoryImpl({
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
    this._overrideStorageDirectory,
  }) : _mainDbLoader = mainDbLoader ?? const MainDbLoader(),
       _deckDbLoader = deckDbLoader ?? const DeckDbLoader();

  @override
  Future<GeneratedDeckResult> generateDeck(
    DeckGenerationRequest request,
  ) async {
    // Simulate generation latency
    await Future.delayed(const Duration(milliseconds: 1000));

    // Support intentional error simulation for testing
    if (request.name.toLowerCase().contains('error') ||
        request.name.toLowerCase().contains('gagal')) {
      return GeneratedDeckResult.failure(
        'Simulated AI service generation error.',
      );
    }

    final deckId =
        'gen_${DateTime.now().millisecondsSinceEpoch}_${randomChar(8)}';
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // Generated sample cards tailored to the requested language
    final generatedCards = _buildSampleCards(request);

    // 1. Commit deck to basa.sqlite
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );
    try {
      final stmt = mainDb.prepare('''
        INSERT OR REPLACE INTO decks (
          id, name, language, difficulty, description, rolePlay,
          explanationRolePlay, activeTime, lastStudiedAt, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''');
      stmt.execute([
        deckId,
        request.name,
        request.language,
        request.difficulty,
        request.description,
        'AI generated assistant',
        request.description.isEmpty
            ? 'Kosakata harian terstruktur'
            : request.description,
        0,
        null,
        nowMs,
        nowMs,
      ]);
      stmt.close();
    } finally {
      mainDb.close();
    }

    // 2. Commit cards to deck_<uuid>.sqlite
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deckId,
      overrideDirectory: _overrideStorageDirectory,
    );
    try {
      final stmt = deckDb.prepare('''
        INSERT OR REPLACE INTO cards (
          idCard, defaultLanguage, translation, phoneticLang, audioPath,
          additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''');

      for (final card in generatedCards) {
        stmt.execute([
          card['idCard'],
          card['defaultLanguage'],
          card['translation'],
          card['phoneticLang'],
          null,
          card['additionalContext'],
          0,
          0,
          0,
          nowMs,
          nowMs,
        ]);
      }
      stmt.close();
    } finally {
      deckDb.close();
    }

    return GeneratedDeckResult(
      deckId: deckId,
      name: request.name,
      cardCount: generatedCards.length,
      isSuccess: true,
    );
  }

  List<Map<String, dynamic>> _buildSampleCards(DeckGenerationRequest request) {
    return [
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Halo / Selamat datang',
        'translation': 'Hello / Welcome',
        'phoneticLang': 'Konnichiwa',
        'additionalContext': 'Salam umum ketika bertemu seseorang.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Terima kasih banyak',
        'translation': 'Thank you very much',
        'phoneticLang': 'Arigatou gozaimasu',
        'additionalContext': 'Bentuk sopan untuk berterima kasih.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Sampai jumpa besok',
        'translation': 'See you tomorrow',
        'phoneticLang': 'Mata ashita',
        'additionalContext': 'Salam perpisahan santai antar teman.',
      },
    ];
  }
}
