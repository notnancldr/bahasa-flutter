sealed class NotificationEvent {
  const NotificationEvent();
}

class LoadNotificationSettingsEvent extends NotificationEvent {
  const LoadNotificationSettingsEvent();
}

class ToggleNotificationEvent extends NotificationEvent {
  final bool isEnabled;
  const ToggleNotificationEvent(this.isEnabled);
}

