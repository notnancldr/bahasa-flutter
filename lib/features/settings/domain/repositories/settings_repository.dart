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
}
