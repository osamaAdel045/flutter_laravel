import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/viewmodels/base_model.dart';
import 'package:flutter_laravel/ui/components/separator.dart';

import '../models/user.dart';
import '../../locator.dart';
import 'api.dart';

class ServerService extends BaseModel{
  Api _api = locator<Api>();

  StreamController<bool> serverData = StreamController<bool>();
  List<Server> servers = [];


  Future getServers() async {
    print('getServers');

    servers = (await _api.getServers())!;
    notifyListeners();
  }
  void rebootServer(Server? server) async {
    await _api.rebootServer(server!.id);
  }
  void deploySite(String serverId, String siteId) async {
    await _api.deploySite(serverId, siteId);
  }
  void enableQuickDeployment(String serverId, String siteId) async {
    await _api.enableQuickDeployment(serverId, siteId);
  }
  void disableQuickDeployment(String serverId, String siteId) async {
    await _api.disableQuickDeployment(serverId, siteId);
  }
  void rebootPostgres(Server? server) async {
    await _api.rebootPostgres(server!.id);
  }
  void rebootNginx(Server? server) async {
    await _api.rebootNginx(server!.id);
  }
  void rebootMysql(Server? server) async {
    await _api.rebootMysql(server!.id);
  }
  void rebootPHP(Server? server) async {
    await _api.rebootPHP(server!.id);
  }

  Future refreshServer(Server server) async {
    var _server = await _api.getServer(server.id);
    var index = servers.indexWhere((s) => s.id == server.id);
    servers[index] = _server!;
    notifyListeners();
  }

  Future<List<Site>?> getSites(Server? server) async {
    List<Site>? _sites;
    _sites = await _api.getSites(server!.id);
    return _sites;
  }

  Future<List<DatabaseModel>?> getDatabases(Server? server) async {
    List<DatabaseModel>? _databaseModels;
    _databaseModels = await _api.getDatabases(server!.id);
    return _databaseModels;
  }

  Future<String?> getEnv(String serverId, String siteId) async {
    String? env;
    env = await _api.getEnv(serverId, siteId);
    return env;
  }

  Future<String?> getNginx(String serverId, String siteId) async {
    String? nginx;
    nginx = await _api.getNginx(serverId, siteId);
    return nginx;
  }

  Future<bool> updateEnv(String serverId, String siteId,String newEnv) async {
    bool response;
    response = await _api.updateEnv(serverId, siteId,newEnv);
    return response;
  }
  Future<bool> updateNginx(String serverId, String siteId,String newNginx) async {
    bool response;
    response = await _api.updateNginx(serverId, siteId,newNginx);
    return response;
  }
  Future<bool> executeCommand(String serverId, String siteId,String command) async {
    bool response;
    response = await _api.executeCommand(serverId, siteId,command);
    return response;
  }
  Future<bool> deleteDatabase(String serverId, String databaseId) async {
    bool response;
    response = await _api.deleteDatabase(serverId, databaseId);
    return response;
  }
}
