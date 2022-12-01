import 'dart:async';

import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'base_model.dart';

class SettingsModel extends BaseModel {
  String? _token;
  String? get token => _token;

  Future getSettings() async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(FORGE_TOKEN_KEY);
    setState(ViewState.Idle);
  }

  Future logout() async {
    setState(ViewState.Busy);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(FORGE_TOKEN_KEY);

    setState(ViewState.Idle);
  }
}
