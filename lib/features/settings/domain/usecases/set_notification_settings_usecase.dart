import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class SetNotificationSettingsUseCase {
  final SettingsRepository _repository;
  const SetNotificationSettingsUseCase(this._repository);

  Future<void> call(NotificationSettings settings) =>
      _repository.setNotificationSettings(settings);
}

