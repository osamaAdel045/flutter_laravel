import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'init_notifications.dart';

Future<void> showNotification(RemoteMessage message) async {
  if (flutterLocalNotificationsPlugin == null) {
    await initNotifications();
  }

  final data = message.data;

  const channelId = 'forge.new_deployment';
  await flutterLocalNotificationsPlugin?.show(
    1,
    '${data['site_name']} has New Deployment',
    '${data['commit_author']} has committed ${data['commit_message']} on ${data['server_name']}.${data['site_name']}',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'Flutter Forge',
        channelDescription: 'Flutter Forge new deployment notification channel',
        importance: Importance.max,
        priority: Priority.high,
        groupKey: 'com.android.example.flutter_laravel.NEW_DEPLOYMENT',
      ),
      iOS: DarwinNotificationDetails(),
    ),
    payload: jsonEncode({
      'server_id': data['server_id'],
      'site_id': data['site_id'],
    }),
  );
}
