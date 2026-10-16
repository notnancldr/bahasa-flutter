import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class SetThemeModeUseCase {
  final SettingsRepository _repository;
  const SetThemeModeUseCase(this._repository);

  Future<void> call(AppThemeMode themeMode) =>
      _repository.setThemeMode(themeMode);
}
