import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class WalkForegroundService {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'walk_recording',
        channelName: 'かさんぽ',
        channelDescription: 'お散歩ルートをGPSで記録しています',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
      ),
    );
  }

  static Future<void> start() async {
    if (await FlutterForegroundTask.isRunningService) return;

    final perm = await FlutterForegroundTask.checkNotificationPermission();
    if (perm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    await FlutterForegroundTask.startService(
      serviceId: 101,
      notificationTitle: 'かさんぽ',
      notificationText: 'お散歩ルートをGPSで記録しています',
    );
  }

  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}
