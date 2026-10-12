import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/notification_settings_model.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _settingsDataSource;

  SettingsRepositoryImpl({
    required this._settingsDataSource,
  });

  @override
  Future<AppThemeMode> getThemeMode() async {
    return _settingsDataSource.getThemeMode();
  }

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _settingsDataSource.saveThemeMode(themeMode);
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    return _settingsDataSource.getNotificationSettings();
  }

  @override
  Future<void> setNotificationSettings(NotificationSettings settings) async {
    final model = NotificationSettingsModel.fromEntity(settings);
    await _settingsDataSource.saveNotificationSettings(model);
  }
}

