import 'dart:async';


import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/ui/components/snack.dart';

import '../../locator.dart';
import 'base_model.dart';

class DatabaseViewModel extends BaseModel {
  Api _api = locator<Api>();

  Future<bool> addDatabase(String serverId, String databaseName) async {
    bool response = false;
    try {
      setState(ViewState.Busy);
      response = await _api.addDatabase(serverId, databaseName);
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      response = false;
    }
    Snack.show(response ? 'Added database successfully' : 'Failed to add database', response);
    return response;
  }

  Future<bool> changePassword(String serverId, String password) async {
    bool response = false;
    try {
      setState(ViewState.Busy);
      response = await _api.changePassword(serverId, password);
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      response = false;
    }
    Snack.show(response ? 'Changed password successfully' : 'Failed to change password', response);
    return response;
  }

  Future<bool> addDatabaseUser(String serverId, String databaseName, String userName, String password) async {
    bool response = false;
    try {
      setState(ViewState.Busy);
      response = await _api.addDatabaseUser(serverId, databaseName, userName, password);
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      response = false;
    }
    Snack.show(response ? 'Added user successfully' : 'Failed to add user', response);
    return response;
  }
}