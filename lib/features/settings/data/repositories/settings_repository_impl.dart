import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/notification_settings_model.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource settingsDataSource;

  SettingsRepositoryImpl({required this.settingsDataSource});

  @override
  Future<AppThemeMode> getThemeMode() async {
    return settingsDataSource.getThemeMode();
  }

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await settingsDataSource.saveThemeMode(themeMode);
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    return settingsDataSource.getNotificationSettings();
  }

  @override
  Future<void> setNotificationSettings(NotificationSettings settings) async {
    final model = NotificationSettingsModel.fromEntity(settings);
    await settingsDataSource.saveNotificationSettings(model);
  }

  @override
  Future<AiModelType> getAiModelPreference() async {
    return settingsDataSource.getAiModelPreference();
  }

  @override
  Future<void> setAiModelPreference(AiModelType mode) async {
    await settingsDataSource.saveAiModelPreference(mode);
  }

  @override
  Future<String?> getGeminiApiKey() async {
    return settingsDataSource.getGeminiApiKey();
  }

  @override
  Future<void> setGeminiApiKey(String apiKey) async {
    await settingsDataSource.saveGeminiApiKey(apiKey);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return settingsDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await settingsDataSource.saveOnboardingCompleted(completed);
  }

  @override
  Future<bool> canGenerateOnlineDeckToday() async {
    return settingsDataSource.canGenerateOnlineDeckToday();
  }

  @override
  Future<void> recordOnlineDeckGeneration() async {
    await settingsDataSource.recordOnlineDeckGeneration();
  }
}
