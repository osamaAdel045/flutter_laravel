import 'package:dio/dio.dart';
import 'package:flutter_laravel/constants.dart';
import 'package:flutter_laravel/core/services/server_service_service.dart';
import 'package:flutter_laravel/core/viewmodels/Menu_bar_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/database_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/deployments_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/recipes_model.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/core/viewmodels/settings_model.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/api.dart';
import 'core/services/authentication_service.dart';
import 'core/viewmodels/login_model.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => ServerService());
  locator.registerLazySingleton(() => Api());

  locator.registerLazySingleton(
    () => Dio()
      ..options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      }
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest:  (RequestOptions options, handler) async {
            var prefs = await SharedPreferences.getInstance();
            var token = prefs.getString(FORGE_TOKEN_KEY);

            if (token != null) {
              options.headers
                  .putIfAbsent('Authorization', () => "Bearer $token");
            }
            // return options;
          },
          onResponse: (Response response,handler) {
            // return response; // continue
          },
          onError: (DioError e,List) {
            if (e.response?.statusCode == 401) {
              navigatorKey.currentState?.pushReplacementNamed(Routes.login);
            }
            // return e;
          },
        ),
      ),
  );

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => RecipesModel());
  locator.registerFactory(() => ServersViewModel());
  locator.registerFactory(() => DatabaseViewModel());
  locator.registerFactory(() => DeploymentsViewModel());
  locator.registerFactory(() => SettingsModel());
  // locator.registerLazySingleton(() => MenuBarViewModel());
}
