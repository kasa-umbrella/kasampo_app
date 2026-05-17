import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _androidChannelId = 'walk_alerts';
  static const _androidChannelName = 'ウォーク通知';

  static const _androidDetails = AndroidNotificationDetails(
    _androidChannelId,
    _androidChannelName,
    importance: Importance.high,
    priority: Priority.high,
    playSound: false,
  );

  static const _iosDetails = DarwinNotificationDetails(
    presentSound: false,
  );

  static const _details = NotificationDetails(
    android: _androidDetails,
    iOS: _iosDetails,
  );

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  static Future<void> showSpeedExceeded() => _plugin.show(
        id: 1,
        title: 'かさんぽ',
        body: '速度が速すぎるため記録をスキップしています',
        notificationDetails: _details,
      );

  static Future<void> showSpeedResumed() => _plugin.show(
        id: 2,
        title: 'かさんぽ',
        body: '記録を再開しました',
        notificationDetails: _details,
      );
}