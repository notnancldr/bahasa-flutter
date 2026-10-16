/// Domain entity representing notification preferences.
class NotificationSettings {
  final bool isEnabled;

  const NotificationSettings({required this.isEnabled});

  NotificationSettings copyWith({bool? isEnabled}) {
    return NotificationSettings(isEnabled: isEnabled ?? this.isEnabled);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettings &&
          runtimeType == other.runtimeType &&
          isEnabled == other.isEnabled;

  @override
  int get hashCode => isEnabled.hashCode;
}
