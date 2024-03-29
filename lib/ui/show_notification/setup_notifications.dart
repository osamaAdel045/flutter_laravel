import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_laravel/debouncer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_laravel/ui/show_notification/init_notifications.dart';

import 'show_notification.dart';
import 'supports_firebase.dart';

abstract class SetupFCM {
  static final Debouncer _debouncer = Debouncer();

  static DatabaseReference get ref => FirebaseDatabase.instance.ref('tokens');

  static Future _sendFCMToServer(String? fcmToken) async {
    if (fcmToken == null) return;
    try {
      // await post(Uri.parse(serverNotificationsFCMApi), body: {
      //   'token': fcmToken,
      // }).then((value) => print('RESPONSE ${value.body}'));
      ref.runTransaction((value) {
        final val = [];
        if (value != null && value is Iterable && value.isNotEmpty) {
          val.addAll(value);
        }
        if (!val.contains(fcmToken)) {
          return Transaction.success([...(val), fcmToken]);
        }
        return Transaction.abort();
      });
    } catch (e) {
      print(e);
    }
  }

  static Future _removeFCMFromServer(String? fcmToken) async {
    if (fcmToken == null) return;
    try {
      // await delete(Uri.parse(serverNotificationsFCMApi), body: {
      //   'token': fcmToken,
      // }).then((value) => print('RESPONSE ${value.body}'));
      ref.runTransaction((value) {
        final val = [];
        if (value != null && value is Iterable && value.isNotEmpty) {
          val.addAll(value);
        }
        if (val.isNotEmpty) {
          return Transaction.success([...val.where((e) => e != fcmToken)]);
        }
        return Transaction.abort();
      });
    } catch (e) {
      print(e);
    }
  }

  static final List<StreamSubscription> _subs = [];

  static void init() {
    if (supportsFirebase) {
      _debouncer.run(() => _initFCM(), 2000);
    }
  }

  static void _initFCM() async {
    if(flutterLocalNotificationsPlugin==null){
      await initNotifications();
    }

    final details = await flutterLocalNotificationsPlugin?.getNotificationAppLaunchDetails();
    if(details?.notificationResponse != null){
      onNotificationTapped(details!.notificationResponse!);
    }

    final fcmToken = await FirebaseMessaging.instance.getToken();

    print('FCM : $fcmToken');

    _sendFCMToServer(fcmToken);

    _subs.add(FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) => _sendFCMToServer(fcmToken)));

    _subs.add(FirebaseMessaging.onMessage.listen((event) => showNotification(event)));

    FirebaseMessaging.onBackgroundMessage(showNotification);
  }

  static void logout() async {
    if (supportsFirebase) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await _removeFCMFromServer(fcmToken);
    }
  }

  static void dispose() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
  }
}
