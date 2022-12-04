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

class ServersViewModel extends BaseModel {
  Api _api = locator<Api>();
  List<Server> _servers = <Server>[];

  List<Server> get servers => _servers;

  Future getServers() async {
    print('getServers');

    setState(ViewState.Busy);
    _servers = (await _api.getServers())!;
    setState(ViewState.Idle);
  }
  void rebootServer(Server? server) async {
    setState(ViewState.Busy);
    await _api.rebootServer(server!.id);
    setState(ViewState.Idle);
  }
  void deploySite(String serverId, String siteId) async {
    setState(ViewState.Busy);
    await _api.deploySite(serverId, siteId);
    setState(ViewState.Idle);
  }
  void enableQuickDeployment(String serverId, String siteId) async {
    setState(ViewState.Busy);
    await _api.enableQuickDeployment(serverId, siteId);
    setState(ViewState.Idle);
  }
  void disableQuickDeployment(String serverId, String siteId) async {
    setState(ViewState.Busy);
    await _api.disableQuickDeployment(serverId, siteId);
    setState(ViewState.Idle);
  }
  void rebootPostgres(Server? server) async {
    setState(ViewState.Busy);
    await _api.rebootPostgres(server!.id);
    setState(ViewState.Idle);
  }
  void rebootNginx(Server? server) async {
    setState(ViewState.Busy);
    await _api.rebootNginx(server!.id);
    setState(ViewState.Idle);
  }
  void rebootMysql(Server? server) async {
    setState(ViewState.Busy);
    await _api.rebootMysql(server!.id);
    setState(ViewState.Idle);
  }
  void rebootPHP(Server? server) async {
    setState(ViewState.Busy);
    await _api.rebootPHP(server!.id);
    setState(ViewState.Idle);
  }

  Future refreshServer(Server server) async {
    var _server = await _api.getServer(server.id);
    var index = _servers.indexWhere((s) => s.id == server.id);
    _servers[index] = _server!;
    notifyListeners();
  }

  Future<List<Site>?> getSites(Server? server) async {
    setState(ViewState.Busy);
    List<Site>? _sites;
    _sites = await _api.getSites(server!.id);
    setState(ViewState.Idle);
    return _sites;
  }

  Future<List<DatabaseModel>?> getDatabases(Server? server) async {
    setState(ViewState.Busy);
    List<DatabaseModel>? _databaseModels;
    _databaseModels = await _api.getDatabases(server!.id);
    setState(ViewState.Idle);
    return _databaseModels;
  }

  Future<String?> getEnv(String serverId, String siteId) async {
    setState(ViewState.Busy);
    String? env;
    env = await _api.getEnv(serverId, siteId);
    setState(ViewState.Idle);
    return env;
  }

  Future<String?> getNginx(String serverId, String siteId) async {
    setState(ViewState.Busy);
    String? nginx;
    nginx = await _api.getNginx(serverId, siteId);
    setState(ViewState.Idle);
    return nginx;
  }

  Future<bool> updateEnv(String serverId, String siteId,String newEnv) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.updateEnv(serverId, siteId,newEnv);
    setState(ViewState.Idle);
    return response;
  }
  Future<bool> updateNginx(String serverId, String siteId,String newNginx) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.updateNginx(serverId, siteId,newNginx);
    setState(ViewState.Idle);
    return response;
  }
  Future<bool> executeCommand(String serverId, String siteId,String command) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.executeCommand(serverId, siteId,command);
    setState(ViewState.Idle);
    return response;
  }
  Future<bool> deleteDatabase(String serverId, String databaseId) async {
    setState(ViewState.Busy);
    bool response;
    response = await _api.deleteDatabase(serverId, databaseId);
    setState(ViewState.Idle);
    return response;
  }
}
