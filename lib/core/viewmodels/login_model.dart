import 'dart:async';

import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../locator.dart';
import 'base_model.dart';

class LoginModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String? errorMessage;

  Future<bool> login(String token) async {
    print('login 1');
    errorMessage = null;
    setState(ViewState.Busy);

    if (token == null || token == '') {
      errorMessage = 'Token is required';
      setState(ViewState.Idle);
      return false;
    }
    bool success = false;

    success = await _authenticationService.login(token);

    if (success == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(FORGE_TOKEN_KEY, token);
    } else {
      errorMessage = 'Token is invalid';
    }

    setState(ViewState.Idle);
    return success;
  }

  Future<bool> checkAuth() async {
    setState(ViewState.Busy);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(FORGE_TOKEN_KEY);

    bool success = false;

    if (token != null) {
      success = await _authenticationService.login(token);
      if (success == false) {
        prefs.remove(FORGE_TOKEN_KEY);
      }
    }

    setState(ViewState.Idle);
    return success;
  }
}
