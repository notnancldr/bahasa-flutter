import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({required super.isEnabled});

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      isEnabled: json['is_enabled'] as bool? ?? true,
    );
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(isEnabled: entity.isEnabled);
  }

  Map<String, dynamic> toJson() {
    return {'is_enabled': isEnabled};
  }
}
