import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/data/models/app_theme_mode_model.dart';
import 'package:bahasa/features/settings/data/models/notification_settings_model.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> saveThemeMode(AppThemeMode themeMode);
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettingsModel settings);
  Future<AiModelType> getAiModelPreference();
  Future<void> saveAiModelPreference(AiModelType mode);
  Future<String?> getGeminiApiKey();
  Future<void> saveGeminiApiKey(String apiKey);
  Future<bool> isOnboardingCompleted();
  Future<void> saveOnboardingCompleted(bool completed);
  Future<bool> canGenerateOnlineDeckToday();
  Future<void> recordOnlineDeckGeneration();
  Future<void> resetOnlineDeckGeneration();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _themeKey = 'app_theme_mode';
  static const _notificationsKey = 'app_notifications_enabled';
  static const _aiModelKey = 'app_ai_model_preference';
  static const _geminiApiKey = 'app_gemini_api_key';
  static const _onboardingKey = 'app_onboarding_completed';
  static const _lastOnlineDeckDateKey = 'app_last_online_deck_date';

  final SharedPreferences? _prefs;

  SettingsLocalDataSourceImpl([this._prefs]);

  String _formatTodayDate() {
    final now = DateTime.now();
    final y = now.year.toString();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await _getPrefs();
    final value = prefs.getString(_themeKey);
    return AppThemeModeModel.fromStorage(value);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_themeKey, AppThemeModeModel.toStorage(themeMode));
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final prefs = await _getPrefs();
    final isEnabled = prefs.getBool(_notificationsKey) ?? true;
    return NotificationSettingsModel(isEnabled: isEnabled);
  }

  @override
  Future<void> saveNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationsKey, settings.isEnabled);
  }

  @override
  Future<AiModelType> getAiModelPreference() async {
    final prefs = await _getPrefs();
    final val = prefs.getString(_aiModelKey);
    return AiModelType.fromStorage(val);
  }

  @override
  Future<void> saveAiModelPreference(AiModelType mode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_aiModelKey, mode.toStorage());
  }

  @override
  Future<String?> getGeminiApiKey() async {
    final prefs = await _getPrefs();
    final key = prefs.getString(_geminiApiKey);
    if (key != null && key.isNotEmpty) return key;
    // Fallback to dart-define environment variable if configured
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return null;
  }

  @override
  Future<void> saveGeminiApiKey(String apiKey) async {
    final prefs = await _getPrefs();
    await prefs.setString(_geminiApiKey, apiKey.trim());
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> saveOnboardingCompleted(bool completed) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_onboardingKey, completed);
  }

  @override
  Future<bool> canGenerateOnlineDeckToday() async {
    final prefs = await _getPrefs();
    final isOnboarded = prefs.getBool(_onboardingKey) ?? false;
    if (!isOnboarded) {
      await prefs.remove(_lastOnlineDeckDateKey);
      return true;
    }

    final lastDate = prefs.getString(_lastOnlineDeckDateKey);
    return lastDate != _formatTodayDate();
  }

  @override
  Future<void> recordOnlineDeckGeneration() async {
    final prefs = await _getPrefs();
    await prefs.setString(_lastOnlineDeckDateKey, _formatTodayDate());
  }

  @override
  Future<void> resetOnlineDeckGeneration() async {
    final prefs = await _getPrefs();
    await prefs.remove(_lastOnlineDeckDateKey);
  }
}
