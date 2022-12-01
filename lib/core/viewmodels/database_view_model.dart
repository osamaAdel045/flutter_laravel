import 'dart:async';


import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/api.dart';

import '../../locator.dart';
import 'base_model.dart';

class DatabaseViewModel extends BaseModel {
  Api _api = locator<Api>();

  Future<bool> addDatabase(String serverId,String databaseName) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.addDatabase(serverId, databaseName);
    setState(ViewState.Idle);
    return response;
  }
  Future<bool> changePassword(String serverId,String password) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.changePassword(serverId, password);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> addDatabaseUser(String serverId,String databaseName,String userName, String password) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.addDatabaseUser(serverId, databaseName,userName,password);
    setState(ViewState.Idle);
    return response;
  }
}