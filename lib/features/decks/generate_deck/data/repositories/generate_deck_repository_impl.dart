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
        'defaultLanguage': 'Halo',
        'translation': 'Konnichiwa',
        'phoneticLang': '/kon.ni.tɕi.wa/',
        'additionalContext': 'Sapaan umum yang digunakan sepanjang hari, setara dengan "halo" dalam bahasa Indonesia.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Terima kasih banyak',
        'translation': 'Arigatou gozaimasu',
        'phoneticLang': '/a.ɾi.ɡa.toː ɡo.za.i.ma.sɯ/',
        'additionalContext':
            'Bentuk sopan untuk mengucapkan terima kasih kepada orang lain.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Selamat tinggal',
        'translation': 'Sayounara',
        'phoneticLang': '/sa.joː.na.ɾa/',
        'additionalContext': 'Salam perpisahan formal ketika berpisah untuk waktu yang cukup lama.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Selamat pagi',
        'translation': 'Ohayou gozaimasu',
        'phoneticLang': '/o.ha.joː ɡo.za.i.ma.sɯ/',
        'additionalContext': 'Sapaan sopan yang digunakan pada pagi hari hingga menjelang siang.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Selamat malam',
        'translation': 'Konbanwa',
        'phoneticLang': '/kom.baɰ̃.wa/',
        'additionalContext':
            'Sapaan yang digunakan ketika bertemu seseorang pada malam hari.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Mohon maaf',
        'translation': 'Gomen nasai',
        'phoneticLang': '/ɡo.men na.sa.i/',
        'additionalContext':
            'Digunakan untuk meminta maaf secara tulus atas kesalahan.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Permisi',
        'translation': 'Sumimasen',
        'phoneticLang': '/sɯ.mi.ma.seɴ/',
        'additionalContext': 'Ungkapan sopan untuk menarik perhatian, meminta izin, atau meminta maaf ringan.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Sampai jumpa besok',
        'translation': 'Mata ashita',
        'phoneticLang': '/ma.ta a.ɕi.ta/',
        'additionalContext': 'Salam perpisahan santai antar teman yang akan bertemu kembali besok.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Senang bertemu dengan anda',
        'translation': 'Hajimemashite',
        'phoneticLang': '/ha.dʑi.me.ma.ɕi.te/',
        'additionalContext':
            'Ungkapan perkenalan saat pertama kali bertemu dengan seseorang.',
      },
      {
        'idCard': 'c_${randomChar(8)}',
        'defaultLanguage': 'Selamat makan',
        'translation': 'Itadakimasu',
        'phoneticLang': '/i.ta.da.ki.ma.sɯ/',
        'additionalContext': 'Ungkapan rasa syukur yang diucapkan sebelum mulai menyantap hidangan.',
      },
    ];
  }
}
