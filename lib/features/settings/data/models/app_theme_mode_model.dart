import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';

class AppThemeModeModel {
  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.fromString(value);
  }

  static String toStorage(AppThemeMode mode) {
    return mode.toStorageString();
  }
}

