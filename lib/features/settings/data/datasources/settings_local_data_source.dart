import 'package:bahasa/features/settings/data/models/app_theme_mode_model.dart';
import 'package:bahasa/features/settings/data/models/notification_settings_model.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> saveThemeMode(AppThemeMode themeMode);
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _themeKey = 'app_theme_mode';
  static const _notificationsKey = 'app_notifications_enabled';

  final SharedPreferences? _prefs;

  SettingsLocalDataSourceImpl([this._prefs]);

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
  Future<void> saveNotificationSettings(NotificationSettingsModel settings) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationsKey, settings.isEnabled);
  }
}

