import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'supports_firebase.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future initNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (supportsFirebase) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  await flutterLocalNotificationsPlugin?.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      // iOS: DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification),
      // macOS: DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification),
      linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
    ),
    onDidReceiveNotificationResponse: (details) async {},
  );
}
