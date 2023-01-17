import 'dart:convert';

import 'package:flutter_laravel/constants.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'supports_firebase.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future initNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (supportsFirebase) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  await flutterLocalNotificationsPlugin?.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      // iOS: DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification),
      // macOS: DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification),
      linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
    ),
    onDidReceiveNotificationResponse: onNotificationTapped,
  );
}

void onNotificationTapped(NotificationResponse details) async {
  final payload = details.payload;
  if (payload != null) {
    final data = jsonDecode(payload);
    final serverId = int.tryParse(data['server_id'] ?? '');
    final siteId = int.tryParse(data['site_id'] ?? '');
    if (serverId != null && siteId != null) {
      final api = locator<Api>();
      final server = await api.getServer(serverId);
      if (server != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.server,
          arguments: server,
        );
        final site = await api.getSite(serverId,siteId);
        if (site != null) {
          navigatorKey.currentState?.pushNamed(
            Routes.site,
            arguments: [site, server],
          );
        }
      }
    }
  }
}
