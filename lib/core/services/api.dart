import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_laravel/constants.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/user.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/server_types.dart';
import '../models/site.dart';

/// The service responsible for networking requests
class Api {
  static const endpoint = 'https://forge.laravel.com/api/v1';
  Dio dio = locator<Dio>();
  Options options = Options(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOTExZjIzZTM3MzAzODA5M2MxNDVhMTBjZTcwMzQ4NzJkMzEzOGY3NjQ5NDE4MmQzMjY0N2NjYTY2OTE3YjE3ODllY2VjNzY1ZGIzMzI1ZTEiLCJpYXQiOjE2Njk1NTI2NjAuNzc1NjM2LCJuYmYiOjE2Njk1NTI2NjAuNzc1NjQsImV4cCI6MTk4NTE3MTg2MC43NzAzNDYsInN1YiI6IjE4MzQ1NCIsInNjb3BlcyI6W119.X49aCqBoHEYXo6JWXhftrilf9icgYLI4EpdSOh-f_0sHEQoovrWiIEax4HnzO8BctECQLEwwzu2_RVvk8o8dy8Rqq_vS7ZxFPypwRr85pHQEiYNkVb6XWT8aYJt7P5_uVJxFtWmmrtN7IDaLwNQp4t0sOQ-vcwI_pliV1FjOi9vhwr0kaqwDuPjLvMqaz5JdP4ICDjRy1xyFVIx39QOFXvJ2Y02I_l4l977jhhuUbmMhIVr3u7HBlLHieoxPrSV7rr1X2QQbvaOKX5hI3571nLtl1kWcEZuUnLcZtn7HihoQVFoOjd3_Ksix-R1-Pwyl8HfLxflEMIdew50pn0su6pgxfhyu9FjQqZvR6s7esbBp6cRoSf-hlZLTKtD79tG_rSw7TUHBYzNW3njb4Zq8rFBo3yDmL-0xFHwHjpoIp6gPpWY0jHdMaLT9OOi9bkBi27g5Zufcn0x7tTv4cD_1lxd-dHQDBM0-gVK-_5GbBKXAyDyQmMwXA5JAI-koPCLdLSUDcHPgyq9g7gFJrTTrvOrNzDGookJjoUVNx-C2QP34cwW_5NdbeTJlM3g5tDXUUjbOWY4CDhJd94_2qOEKMyFoKUbrGwrTu8JM16VxAmeltkLmzhCFqVsJFbgGg3Jjl2HK_gvEAh93b52umfDZo_f0nRHjtS9Vrh8y7b6376A',
    },
    receiveTimeout: 60 * 1000,
  );

  String? token;

  Future<User?> getUserProfile(String? token) async {
    this.token = token;

    var request = Dio()
      ..options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      };
    var response;

    try {
      response = await request.get('$endpoint/user');
      print("getUserProfile response");
      print(response);
    } catch (e) {
      print("getUserProfile response e");
      print(e);

      return null;
    }
    print('response');
    print(response);

    return User.fromJson(response.data['user']);
  }

  Future<List<Server>?> getServers() async {
    List<Server> servers = <Server>[];
    print('getServers');
    var response = await Dio().get('$endpoint/servers', options: options);
    // print('response');
    // print(response);

    if (response.statusCode != 200) return null;

    var parsed = response.data['servers'] as List<dynamic>;

    for (var serverData in parsed) {
      Server server = Server.fromJson(serverData);
      if (Platform.isMacOS) {                           // getting sites and databases for MacOs MenuBar
        if (ServerTypes.hasSites.contains(server.type!.toLowerCase())) {
          List<Site>? sites = await getSites(server.id);
          server.setSites(sites!);
        }
        if (ServerTypes.hasDatabase.contains(server.type!.toLowerCase())) {
          List<DatabaseModel>? databases = await getDatabases(server.id);
          server.setDatabases(databases!);
        }
      }
      try {
        servers.add(server);
      } catch (e) {
        print('eeee');
        print(e);
      }
    }

    return servers;
  }

  Future<List<DeploymentModel>?> getDeployments(String serverId, String siteId) async {
    List<DeploymentModel> deployments = <DeploymentModel>[];
    print('getDeployments');
    var response =
        await Dio().get('$endpoint/servers/$serverId/sites/$siteId/deployment-history', options: options);

    if (response.statusCode != 200) return null;
    print(response.realUri);

    var parsed = response.data['deployments'] as List<dynamic>;

    for (var deployment in parsed) {
      try {
        deployments.add(DeploymentModel.fromJson(deployment));
      } catch (e, s) {
        print('eeee');
        print(e);
        print(s);
      }
    }

    return deployments;
  }

  Future<List<Recipe>?> getRecipes() async {
    List<Recipe> recipes = <Recipe>[];

    var response = await Dio().get('$endpoint/recipes', options: options);

    print('response recipes');
    print(response);
    if (response.statusCode != 200) return null;

    for (var recipe in response.data['recipes']) {
      recipes.add(Recipe.fromJson(recipe));
    }

    return recipes;
  }

  Future<bool> rebootServer(int? id) async {
    var response = await Dio().post('$endpoint/servers/$id/reboot', options: options);
    print("response");
    print(response);
    return response.statusCode == 200;
  }

  Future<bool> deploySite(String serverId, String siteId) async {
    var response = await Dio().post('$endpoint/servers/$serverId/sites/$siteId/deployment/deploy', options: options);
    return response.statusCode == 200;
  }

  Future<bool> enableQuickDeployment(String serverId, String siteId) async {
    var response = await Dio().post('$endpoint/servers/$serverId/sites/$siteId/deployment', options: options);
    return response.statusCode == 200;
  }

  Future<bool> disableQuickDeployment(String serverId, String siteId) async {
    var response = await Dio().delete('$endpoint/servers/$serverId/sites/$siteId/deployment', options: options);
    return response.statusCode == 200;
  }

  Future<bool> rebootPostgres(int? id) async {
    var response = await Dio().post('$endpoint//servers/$id/postgres/reboot', options: options);
    return response.statusCode == 200;
  }

  Future<bool> rebootNginx(int? id) async {
    var response = await Dio().post('$endpoint//servers/$id/nginx/reboot', options: options);
    return response.statusCode == 200;
  }

  Future<bool> rebootMysql(int? id) async {
    var response = await Dio().post('$endpoint//servers/$id/mysql/reboot', options: options);
    return response.statusCode == 200;
  }

  Future<bool> rebootPHP(int? id) async {
    var response = await Dio().post('$endpoint//servers/$id/php/reboot', options: options);
    return response.statusCode == 200;
  }

  Future<Server?> getServer(int? id) async {
    var response = await Dio().get('$endpoint/servers/${id.toString()}', options: options);

    if (response.statusCode != 200) return null;
    print('response1212');
    print(response);

    return Server.fromJson(response.data['server']);
  }

  Future<List<Site>?> getSites(int? id) async {
    List<Site> sites = <Site>[];

    var response = await Dio().get('$endpoint/servers/$id/sites', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    for (var site in response.data['sites']) {
      sites.add(Site.fromJson(site));
    }

    return sites;
  }

  Future<List<DatabaseModel>?> getDatabases(int? id) async {
    List<DatabaseModel> _databaseModels = <DatabaseModel>[];

    var response = await Dio().get('$endpoint/servers/$id/databases', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    for (var database in response.data['databases']) {
      _databaseModels.add(DatabaseModel.fromJson(database));
    }

    return _databaseModels;
  }

  Future<String?> getEnv(String serverId, String siteId) async {
    String env = "";

    var response = await Dio().get('$endpoint/servers/$serverId/sites/$siteId/env', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    env = response.data;

    return env;
  }

  Future<bool> updateEnv(String serverId, String siteId, String newEnv) async {
    var response = await Dio().put(
      '$endpoint/servers/$serverId/sites/$siteId/env',
      options: options,
      data: {
        'content': newEnv,
      },
    );

    return response.statusCode != 200;
  }

  Future<String?> getNginx(String serverId, String siteId) async {
    String nginx = "";

    var response = await Dio().get('$endpoint/servers/$serverId/sites/$siteId/nginx', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    nginx = response.data;

    return nginx;
  }

  Future<bool> updateNginx(String serverId, String siteId, String newNginx) async {
    var response = await Dio().put(
      '$endpoint/servers/$serverId/sites/$siteId/nginx',
      options: options,
      data: {
        'content': newNginx,
      },
    );

    return response.statusCode != 200;
  }

  Future<bool> executeCommand(String serverId, String siteId, String command) async {
    var response = await Dio().post(
      '$endpoint/servers/$serverId/sites/$siteId/commands',
      options: options,
      data: {
        'command': command,
      },
    );

    return response.statusCode != 200;
  }

  Future<bool> deleteDatabase(String serverId, String databaseId) async {
    var response = await Dio().delete(
      '$endpoint/servers/$serverId/databases/$databaseId',
      options: options,
    );

    return response.statusCode == 200;
  }

  Future<bool> addDatabase(String serverId, String databaseName) async {
    var response = await Dio().post(
      '$endpoint/servers/$serverId/databases',
      options: options,
      data: {
        'name': databaseName,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> changePassword(String serverId, String password) async {
    var response = await Dio().post(
      '$endpoint/servers/$serverId/database-password',
      options: options,
      data: {
        'password': password,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> addDatabaseUser(String serverId, String databaseName, String userName, String password) async {
    var response = await Dio().post(
      '$endpoint/servers/$serverId/databases',
      options: options,
      data: {
        'name': databaseName,
        'user': userName,
        'password': password,
      },
    );

    return response.statusCode == 200;
  }

  Future<String?> getDeploymentLog(String serverId, String siteId, String deploymentId) async {
    String log = "";

    var response = await Dio()
        .get('$endpoint/servers/$serverId/sites/$siteId/deployment-history/$deploymentId/output', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    log = response.data['output'];

    return log;
  }

  Future<Recipe?> updateRecipe(int id, String name, String user, String script) async {
    var response = await Dio().put(
      '$endpoint/recipes/$id',
      options: options,
      data: {
        "name": name,
        "user": user,
        "script": script,
      },
    );
    if (response.statusCode != 200) return null;
    final data = response.data;
    // await Future.delayed(Duration(seconds: 1));
    // final data = {
    //   "recipe": {
    //     "id": 1,
    //     "name": "Recipe Name",
    //     "user": "root",
    //     "script": "SCRIPT_CONTENT",
    //     "created_at": "2016-12-16 16:24:05"
    //   }
    // };
    final json = data['recipe']!;
    return Recipe.fromJson(json);
  }

  Future<Recipe?> addRecipe(String name, String user, String script) async {
    var response = await Dio().post(
      '$endpoint/recipes',
      options: options,
      data: {
        "name": name,
        "user": user,
        "script": script,
      },
    );
    if (response.statusCode != 200) return null;
    final data = response.data;
    // await Future.delayed(Duration(seconds: 1));
    // final data = {
    //   "recipe": {
    //     "id": 1,
    //     "name": "Recipe Name",
    //     "user": "root",
    //     "script": "SCRIPT_CONTENT",
    //     "created_at": "2016-12-16 16:24:05"
    //   }
    // };
    final json = data['recipe']!;
    return Recipe.fromJson(json);
  }

  Future<bool> deleteRecipe(int id) async {
    var response = await Dio().delete('$endpoint/recipes/$id', options: options);
    return response.statusCode == 200;
    // await Future.delayed(Duration(seconds: 1));
    // return true;
  }

  Future<bool> hasNotificationsChannel(String? server, String? site) async {
    try {
      if (server == null) return false;
      if (site == null) return false;
      final response = await Dio().get('$endpoint/servers/$server/sites/$site/webhooks', options: options);
      print('Api.hasNotificationsChannel : ${response.data}');
      final webhooks = response.data?['webhooks'];
      if (webhooks != null && webhooks is List && webhooks.isNotEmpty) {
            return webhooks.any((e) => e?['url'] == serverNotificationsWebHook);
          }
      return false;
    } catch (e,s) {
      print(e);
      print(s);
      return false;
    }
  }

  Future<void> toggleSiteNotification(String? server, String? site, bool value) async {
    try {
      if (server == null) return;
      if (site == null) return;

      if(value){
        final response = await Dio().post('$endpoint/servers/$server/sites/$site/webhooks', options: options,data: {
          "url": serverNotificationsWebHook,
        });
        print('Api.toggleSiteNotification true : ${response.data}');
      }else{
        final response = await Dio().get('$endpoint/servers/$server/sites/$site/webhooks', options: options);
        print('Api.toggleSiteNotification false : ${response.data}');
        final webhooks = response.data?['webhooks'];
        if (webhooks != null && webhooks is List && webhooks.isNotEmpty) {
           if(webhooks.any((e) => e?['url'] == serverNotificationsWebHook)){
             final webhook = webhooks.firstWhere((e) => e?['url'] == serverNotificationsWebHook);
             final response = await Dio().delete('$endpoint/servers/$server/sites/$site/webhooks/${webhook['id']}', options: options);
             print('Api.toggleSiteNotification2 true : ${response.data}');
           }
        }
      }
    } catch (e,s) {
      print(e);
      print(s);
      return;
    }
  }

  Future<Site?> getSite(int? serverId,int? siteId) async {
    var response = await Dio().get('$endpoint/servers/$serverId/sites/$siteId', options: options);
    print(response);

    if (response.statusCode != 200) return null;

    return Site.fromJson(response.data['site']);
  }
}
