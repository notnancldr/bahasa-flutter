import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';

class GetNotificationSettingsUseCase {
  final SettingsRepository _repository;
  const GetNotificationSettingsUseCase(this._repository);

  Future<NotificationSettings> call() => _repository.getNotificationSettings();
}

