import 'dart:async';
import 'dart:io';


import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/core/services/authentication_service.dart';
import 'package:flutter_laravel/core/services/server_service_service.dart';
import 'package:flutter_laravel/ui/components/snack.dart';

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
    if (Platform.isMacOS) {
      locator<ServerService>().serverData.add(true);
      locator<ServerService>().servers = _servers;
    }
    setState(ViewState.Idle);
  }
  void rebootServer(Server? server) async {
    try {
      setState(ViewState.Busy);
      final b = await _api.rebootServer(server!.id);
      setState(ViewState.Idle);
      _showRebootSnack('Server', b);
    } catch (e, s) {
      print(e);
      print(s);
      _showRebootSnack('Server', false);
    }
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
    try {
      setState(ViewState.Busy);
      final b = await _api.rebootPostgres(server!.id);
      setState(ViewState.Idle);
      _showRebootSnack('Postgres',b);
    } catch (e, s) {
      print(e);
      print(s);
      _showRebootSnack('Postgres',false);
    }
  }
  void rebootNginx(Server? server) async {
    try {
      setState(ViewState.Busy);
      final b = await _api.rebootNginx(server!.id);
      setState(ViewState.Idle);
      _showRebootSnack('Nginx',b);
    } catch (e, s) {
      print(e);
      print(s);
      _showRebootSnack('Nginx',false);
    }
  }
  void rebootMysql(Server? server) async {
    try {
      setState(ViewState.Busy);
      final b = await _api.rebootMysql(server!.id);
      setState(ViewState.Idle);
      _showRebootSnack('MySql',b);
    } catch (e, s) {
      print(e);
      print(s);
      _showRebootSnack('MySql',false);
    }
  }
  void rebootPHP(Server? server) async {
    try {
      setState(ViewState.Busy);
      final b = await _api.rebootPHP(server!.id);
      setState(ViewState.Idle);
      _showRebootSnack('PHP',b);
    } catch (e, s) {
      print(e);
      print(s);
      _showRebootSnack('PHP',false);
    }
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

  bool _siteNotificationsOn = false;

  bool get siteNotificationsOn => _siteNotificationsOn;

  Future toggleSiteNotification(int? server,int? site, bool value)async{
    setState(ViewState.Busy);
    await _api.toggleSiteNotification(server?.toString(), site?.toString(),value);
    await hasNotificationsChannel(server, site);
    setState(ViewState.Idle);
  }

  Future<void> hasNotificationsChannel(int? server,int? site)async{
    setState(ViewState.Busy);
    _siteNotificationsOn = await _api.hasNotificationsChannel(server?.toString(), site?.toString());
    setState(ViewState.Idle);
  }

  _showRebootSnack(String type, bool succeed) =>
      Snack.show(succeed ? "Rebooted $type successfully" : "Failed to reboot $type", succeed);
}
