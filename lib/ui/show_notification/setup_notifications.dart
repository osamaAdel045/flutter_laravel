import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_laravel/constants.dart';
import 'package:flutter_laravel/debouncer.dart';
import 'package:flutter_laravel/single_run.dart';
import 'package:http/http.dart';

import 'show_notification.dart';
import 'supports_firebase.dart';

abstract class SetupFCM {
  static final Debouncer _debouncer = Debouncer();

  static Future _sendFCMToServer(String? fcmToken) async {
    try {
      await post(Uri.parse(serverNotificationsFCMApi), body: {
        'token': fcmToken,
      }).then((value) => print('RESPONSE ${value.body}'));
    } catch (e) {
      print(e);
    }
  }

  static Future _removeFCMFromServer(String? fcmToken) async {
    try {
      await delete(Uri.parse(serverNotificationsFCMApi), body: {
        'token': fcmToken,
      }).then((value) => print('RESPONSE ${value.body}'));
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
