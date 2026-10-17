import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';

abstract class SettingsRepository {
  /// Retrieves the current theme mode preference.
  Future<AppThemeMode> getThemeMode();

  /// Persists and updates the theme mode preference.
  Future<void> setThemeMode(AppThemeMode themeMode);

  /// Retrieves the notification settings.
  Future<NotificationSettings> getNotificationSettings();

  /// Persists and updates notification settings.
  Future<void> setNotificationSettings(NotificationSettings settings);

  /// Retrieves the user's selected AI model processing mode (online or local).
  Future<AiModelType> getAiModelPreference();

  /// Persists the user's selected AI model processing mode.
  Future<void> setAiModelPreference(AiModelType mode);

  /// Retrieves the stored Gemini API key (or default from env).
  Future<String?> getGeminiApiKey();

  /// Persists the Gemini API key.
  Future<void> setGeminiApiKey(String apiKey);

  /// Checks if full onboarding (profile creation + AI selection) has been completed.
  Future<bool> isOnboardingCompleted();

  /// Sets whether onboarding has been completed.
  Future<void> setOnboardingCompleted(bool completed);

  /// Checks if online AI deck generation can be performed today (limit: 1 deck per day).
  Future<bool> canGenerateOnlineDeckToday();

  /// Records that an online AI deck generation was completed today.
  Future<void> recordOnlineDeckGeneration();

  /// Resets the daily online AI deck generation tracker.
  Future<void> resetOnlineDeckGeneration();
}
