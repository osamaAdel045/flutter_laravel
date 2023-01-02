import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/ui/views/add_database_view.dart';
import 'package:flutter_laravel/ui/views/change_database_password_view.dart';
import 'package:flutter_laravel/ui/views/deployments_view.dart';
import 'package:flutter_laravel/ui/views/login_view.dart';
import 'package:flutter_laravel/ui/views/main_view.dart';
import 'package:flutter_laravel/ui/views/recipe_view.dart';
import 'package:flutter_laravel/ui/views/server_view.dart';
import 'package:flutter_laravel/ui/views/site_view.dart';

abstract class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String server = "/server";
  static const String recipe = "/recipe";
  static const String addRecipe = "/addRecipe";
  static const String site = "/site";
  static const String deployments = "/deployments";
  static const String addDatabase = "/addDatabase";
  static const String changeDatabasePassword = "/changeDatabasePassword";
}

const String initialRoute = Routes.login;

class Router {
  static get routes => {
        Routes.home: (context) => MainView(),
        Routes.login: (context) => LoginView(),
        Routes.server: (context) {
          var server = ModalRoute.of(context)!.settings.arguments as Server;

          return ServerView(
            server: server,
          );
        },
        Routes.site: (context) {
          var site = (ModalRoute.of(context)!.settings.arguments as List)[0] as Site;
          var server = (ModalRoute.of(context)!.settings.arguments as List)[1] as Server;

          return SiteView(
            site: site,
            server: server,
          );
        },
        Routes.recipe: (context) {
          var recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

          return RecipeView.edit(
            recipe: recipe,
          );
        },
        Routes.addRecipe: (context) {
          return RecipeView.add();
        },
        Routes.deployments: (context) {
          var site = (ModalRoute.of(context)!.settings.arguments as List)[0] as Site;
          var server = (ModalRoute.of(context)!.settings.arguments as List)[1] as Server;

          return DeploymentsView(
            site: site,
            server: server,
          );
        },
        Routes.addDatabase: (context) {
          bool isDatabaseUser= (ModalRoute.of(context)!.settings.arguments as List)[0] as bool;
          var server = (ModalRoute.of(context)!.settings.arguments as List)[1] as Server;
          return AddDatabaseView(isDatabaseUser: isDatabaseUser,server: server,);
        },
        Routes.changeDatabasePassword: (context) {
          var server = (ModalRoute.of(context)!.settings.arguments ) as Server;
          return ChangeDatabasePasswordView(server: server,);
        },
      };
}
