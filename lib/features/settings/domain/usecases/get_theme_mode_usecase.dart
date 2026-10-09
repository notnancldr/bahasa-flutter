import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;
  const GetThemeModeUseCase(this._repository);

  Future<AppThemeMode> call() => _repository.getThemeMode();
}

