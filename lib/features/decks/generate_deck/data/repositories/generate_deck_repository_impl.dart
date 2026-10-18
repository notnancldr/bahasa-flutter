import 'dart:io';

import 'package:bahasa/core/constants/gemini_config.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/decks/generate_deck/data/datasources/gemini_deck_generator_datasource.dart';
import 'package:bahasa/features/decks/generate_deck/data/datasources/local_gemma_deck_generator_datasource.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_deck_model.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';

import '../../domain/entities/deck_generation_request.dart';
import '../../domain/entities/generated_deck_result.dart';
import '../../domain/repositories/generate_deck_repository.dart';

/// Implementation of [GenerateDeckRepository] calling real AI models
/// (Online Gemini or Local Gemma) and persisting results to SQLite databases.
class GenerateDeckRepositoryImpl implements GenerateDeckRepository {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final SettingsRepository _settingsRepository;
  final GeminiDeckGeneratorDataSource _geminiDataSource;
  final LocalGemmaDeckGeneratorDataSource _localGemmaDataSource;
  final ModelDownloadService _downloadService;
  final Directory? _overrideStorageDirectory;

  GenerateDeckRepositoryImpl({
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
    SettingsRepository? settingsRepository,
    GeminiDeckGeneratorDataSource? geminiDataSource,
    LocalGemmaDeckGeneratorDataSource? localGemmaDataSource,
    ModelDownloadService? downloadService,
    this._overrideStorageDirectory,
  }) : _mainDbLoader = mainDbLoader ?? const MainDbLoader(),
       _deckDbLoader = deckDbLoader ?? const DeckDbLoader(),
       _settingsRepository =
           settingsRepository ??
           SettingsDependencies.createSettingsRepository(),
       _geminiDataSource =
           geminiDataSource ?? const GeminiDeckGeneratorDataSource(),
       _localGemmaDataSource =
           localGemmaDataSource ?? const LocalGemmaDeckGeneratorDataSource(),
       _downloadService = downloadService ?? ModelDownloadService();

  @override
  Future<GeneratedDeckResult> generateDeck(
    DeckGenerationRequest request, {
    void Function(int collected, int total)? onProgress,
  }) async {
    try {
      final aiMode = await _settingsRepository.getAiModelPreference();
      final EuyDeckModel deck;

      if (aiMode == AiModelType.local) {
        final modelPath = await _downloadService.getModelPathIfAvailable();
        if (modelPath == null) {
          return GeneratedDeckResult.failure(
            'Local AI model is not ready. Please download it first or switch to Online AI in Settings.',
          );
        }

        deck = await _localGemmaDataSource.generateDeck(
          request: request,
          modelPath: modelPath,
          onProgress: onProgress,
        );
      } else {
        // Enforce online deck generation daily limit (maximum 1 deck per day)
        final canGenerate = await _settingsRepository
            .canGenerateOnlineDeckToday();
        if (!canGenerate) {
          return GeneratedDeckResult.failure(
            'Batas pembuatan deck online tercapai (maksimum 1 deck per hari). Silakan gunakan AI Lokal atau coba lagi besok.',
          );
        }

        // Obtain developer-provided Gemini API key
        final apiKey = GeminiConfig.developerGeminiApiKey;
        if (!GeminiConfig.isConfigured) {
          return GeneratedDeckResult.failure(
            'Gemini API key is not configured by the developer. Please configure GEMINI_API_KEY in the .env file or pass --dart-define=GEMINI_API_KEY=your_key.',
          );
        }

        deck = await _geminiDataSource.generateDeck(
          request: request,
          apiKey: apiKey,
          onProgress: onProgress,
        );
      }

      await _persistDeck(deck);

      if (aiMode != AiModelType.local) {
        await _settingsRepository.recordOnlineDeckGeneration();
      }

      return GeneratedDeckResult(
        deckId: deck.id,
        name: deck.name,
        cardCount: deck.listCards.length,
        isSuccess: true,
      );
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('Failed host lookup') ||
          msg.contains('SocketException') ||
          msg.contains('ClientException')) {
        return GeneratedDeckResult.failure(
          'Tidak ada koneksi internet. Silakan periksa koneksi Wi-Fi/Data seluler Anda atau gunakan AI Lokal (Offline) di Settings.',
        );
      }
      return GeneratedDeckResult.failure(msg);
    }
  }

  Future<void> _persistDeck(EuyDeckModel deck) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // 1. Commit deck record to basa.sqlite
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
        deck.id,
        deck.name,
        deck.language,
        deck.difficulty,
        deck.explanationRolePlay,
        deck.rolePlay,
        deck.explanationRolePlay,
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
      deck.id,
      overrideDirectory: _overrideStorageDirectory,
    );
    try {
      final stmt = deckDb.prepare('''
        INSERT OR REPLACE INTO cards (
          idCard, defaultLanguage, translation, phoneticLang, audioPath,
          additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''');

      for (final card in deck.listCards) {
        stmt.execute([
          card.idCard,
          card.defaultLanguage,
          card.translation,
          card.phoneticLang,
          null,
          card.additionalContext,
          card.reps,
          card.correctAnswer,
          card.finalScore,
          nowMs,
          nowMs,
        ]);
      }
      stmt.close();
    } finally {
      deckDb.close();
    }
  }
}
