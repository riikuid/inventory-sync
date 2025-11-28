import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'constant.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
AndroidNotificationChannel? channel;

final onClickNotification = BehaviorSubject<String>();

class LocalNotification {
  /// Init TIDAK memunculkan permission prompt.
  Future<void> init() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel!);
    }

    // Jangan minta izin di sini. Semua request permission = false.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(notificationIcon);

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// Panggil ini KETIKA kamu ingin minta izin (mis. setelah UI muncul).
  /// `provisional` bisa true jika mau "quiet notifications" di iOS (tanpa pop-up).
  Future<void> requestPermission({bool provisional = false}) async {
    if (Platform.isIOS) {
      // Local notifications iOS
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      // Catatan: permission FCM (remote) kamu minta di AppFirebase (supaya terpisah).
    }

    if (Platform.isAndroid) {
      // Android 13+ perlu izin POST_NOTIFICATIONS
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel!);
    }
  }

  show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) {
    flutterLocalNotificationsPlugin!.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // dev.log('notificationTapBackground payload: ${notificationResponse.payload}');
  if (notificationResponse.payload == null) return;
  onClickNotification.add(notificationResponse.payload!);
}
