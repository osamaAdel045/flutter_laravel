import 'package:flutter/material.dart';

const FORGE_TOKEN_KEY = 'forge_token';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const serverNotificationsBaseUrl = 'https://us-central1-laravel-forge-ac6ae.cloudfunctions.net/app';
const serverNotificationsWebHook = '$serverNotificationsBaseUrl/new_deployment';
const serverNotificationsFCMApi = '$serverNotificationsBaseUrl/fcm_token';