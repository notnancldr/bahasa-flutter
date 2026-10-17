import 'dart:io';

import 'package:bahasa/features/decks/generate_deck/data/repositories/generate_deck_repository_impl.dart';
import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSettingsRepository implements SettingsRepository {
  AiModelType aiModelPreference = AiModelType.online;
  bool canGenerateToday = true;
  bool recordedOnline = false;

  @override
  Future<AiModelType> getAiModelPreference() async => aiModelPreference;

  @override
  Future<void> setAiModelPreference(AiModelType mode) async {
    aiModelPreference = mode;
  }

  @override
  Future<bool> canGenerateOnlineDeckToday() async => canGenerateToday;

  @override
  Future<void> recordOnlineDeckGeneration() async {
    recordedOnline = true;
  }

  @override
  Future<void> resetOnlineDeckGeneration() async {
    recordedOnline = false;
  }

  @override
  Future<String?> getGeminiApiKey() async => null;

  @override
  Future<void> setGeminiApiKey(String apiKey) async {}

  @override
  Future<bool> isOnboardingCompleted() async => true;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {}

  @override
  Future<AppThemeMode> getThemeMode() async => AppThemeMode.system;

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {}

  @override
  Future<NotificationSettings> getNotificationSettings() async =>
      const NotificationSettings(isEnabled: false);

  @override
  Future<void> setNotificationSettings(NotificationSettings settings) async {}
}

class _FakeModelDownloadService extends ModelDownloadService {
  _FakeModelDownloadService() : super.create();

  String? availablePath;

  @override
  Future<String?> getModelPathIfAvailable() async => availablePath;
}

void main() {
  group('GenerateDeckRepositoryImpl', () {
    late _FakeSettingsRepository settingsRepo;
    late _FakeModelDownloadService downloadService;
    late Directory tempDir;

    setUp(() async {
      settingsRepo = _FakeSettingsRepository();
      downloadService = _FakeModelDownloadService();
      tempDir = await Directory.systemTemp.createTemp('gen_deck_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('blocks online generation when daily limit is reached', () async {
      settingsRepo.canGenerateToday = false;

      final repo = GenerateDeckRepositoryImpl(
        settingsRepository: settingsRepo,
        downloadService: downloadService,
        overrideStorageDirectory: tempDir,
      );

      final result = await repo.generateDeck(
        const DeckGenerationRequest(
          name: 'Japanese Vocab',
          language: 'Japanese',
          difficulty: 'beginner',
          description: 'Basic words',
        ),
      );

      expect(result.isSuccess, isFalse);
      expect(
        result.errorMessage,
        contains('Batas pembuatan deck online tercapai'),
      );
    });

    test('fails local generation if local model is not downloaded', () async {
      settingsRepo.aiModelPreference = AiModelType.local;
      downloadService.availablePath = null;

      final repo = GenerateDeckRepositoryImpl(
        settingsRepository: settingsRepo,
        downloadService: downloadService,
        overrideStorageDirectory: tempDir,
      );

      final result = await repo.generateDeck(
        const DeckGenerationRequest(
          name: 'Local Vocab',
          language: 'Japanese',
          difficulty: 'beginner',
          description: 'Basic words',
        ),
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Local AI model is not ready'));
    });
  });
}
