import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Singleton helper managing system notifications for background AI deck generation.
class AppNotificationService {
  static final AppNotificationService _instance =
      AppNotificationService._internal();
  factory AppNotificationService() => _instance;
  AppNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const int _notificationId = 888;
  static const String _channelId = 'deck_generation_channel';
  static const String _channelName = 'Deck Generation';
  static const String _channelDescription =
      'Notifications for AI deck generation progress and completion';

  /// Initializes the local notification plugin and requests permissions on Android 13+.
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    try {
      await _notificationsPlugin.initialize(initSettings);
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      _isInitialized = true;
    } catch (_) {
      // Gracefully handle if notifications plugin is not supported in current environment
    }
  }

  /// Displays or updates an ongoing progress notification with a progress bar.
  Future<void> showProgressNotification({
    required String deckName,
    required int collectedCards,
    required int totalCards,
  }) async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: totalCards,
      progress: collectedCards,
      ongoing: true,
    );

    final details = NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.show(
        _notificationId,
        'Membuat Deck "$deckName"',
        'Terkumpul $collectedCards / $totalCards kartu',
        details,
      );
    } catch (_) {}
  }

  /// Displays a completion notification when deck generation finishes.
  Future<void> showCompletionNotification({
    required String deckName,
    required int totalCards,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.cancel(_notificationId);
      await _notificationsPlugin.show(
        _notificationId + 1,
        'Deck "$deckName" Selesai!',
        '$totalCards kartu telah siap dipelajari.',
        details,
      );
    } catch (_) {}
  }

  /// Displays a failure notification if generation fails.
  Future<void> showFailureNotification({
    required String deckName,
    required String errorMessage,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.cancel(_notificationId);
      await _notificationsPlugin.show(
        _notificationId + 2,
        'Gagal Membuat Deck "$deckName"',
        errorMessage,
        details,
      );
    } catch (_) {}
  }
}
