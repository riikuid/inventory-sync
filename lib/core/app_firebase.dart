// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../firebase_options.dart';
import '../main.dart';
import 'constant.dart';
import 'local_notification.dart';

class AppFirebase {
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') rethrow;
    }

    // Listener boleh disiapkan lebih dulu (tidak memicu prompt).
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });
  }

  /// `provisional: true` = iOS quiet permission (tanpa pop-up)
  static Future<void> requestAndEnablePush({bool provisional = false}) async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: provisional,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await messaging.subscribeToTopic("all");
      // Optional: ambil token, set user id ke Crashlytics, dsb (non-blocking).
      // final token = await messaging.getToken();
      // dev.log('FCM token: $token');
    }
  }

  static Future<void> setupInteractedMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      dev.log('onMessageOpenedApp: ${message.data}');
      handleMessage(context, message.data);
    });

    onClickNotification.stream.listen((payload) {
      dev.log('local_notification onClick: $payload');
      handleMessage(context, payload);
    });
  }
}

void handleMessage(context, dynamic payload) async {
  // dev.log('masuk handleMessage');
  Map<String, dynamic> data;
  if (payload is String) {
    // dev.log('Payload is String');
    data = jsonDecode(payload);
  } else if (payload is Map) {
    data = Map<String, dynamic>.from(payload);
  } else {
    // dev.log('Payload format tidak dikenali');
    return;
  }

  // Mark as read jika id ada
  if (data['id'] != null) {
    final intId = int.tryParse(data['id'].toString());
    if (intId != null) {
      // await BlocProvider.of<NotificationCubit>(context).markAsRead(intId);
      // dev.log('Marked notification $intId as read');
    }
  }

  // Routing sesuai type
  if (data['reference_type'] == 'visit' && data['reference_id'] != null) {
    // dev.log('Navigasi ke visit detail dengan id: ${data['reference_id']}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // GoRouter.of(context).push(
      //   Uri(
      //     path: "${RouteName.visitDetailScreen}/${data['reference_id']}",
      //     queryParameters: {'scrollTo': 'comment'},
      //   ).toString(),
      // );
    });
  }
  // Tambahkan else if untuk type lain jika perlu
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    // Ignore duplicate-app error
  }
  // Tambahkan log di sini untuk memastikan handler berjalan
  // dev.log('Background payload: ${json.encode(message.data)}');
}

void showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (kIsWeb || android == null || notification == null) return;

  String? payload = json.encode(message.data);
  // dev.log('ini payload showLocal: $payload');

  localNotification.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel?.id ?? '',
        channel?.name ?? '',
        channelDescription: channel?.description ?? '',
        playSound: true,
        // color: Colors.white,
        icon: notificationIcon,
      ),
    ),
    payload: payload,
  );
}
