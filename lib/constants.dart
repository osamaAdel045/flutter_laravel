import 'package:flutter/material.dart';

const FORGE_TOKEN_KEY = 'forge_token';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const serverNotificationsBaseUrl = 'http://10.0.0.2:1337';
const serverNotificationsWebHook = '$serverNotificationsBaseUrl/new_deployment';
const serverNotificationsFCMApi = '$serverNotificationsBaseUrl/fcm_token';