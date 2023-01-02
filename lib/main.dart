import 'package:flutter/material.dart';
import 'package:flutter_laravel/desktop_menu_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'core/models/user.dart';
import 'core/services/authentication_service.dart';
import 'locator.dart';
import 'ui/router.dart' as route;

void main() async {
  // await SharedPreferences.getInstance().then((value) => value.clear());
  setupLocator();
  runApp(MyMenuBarApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      initialData: User.initial(),
      create: (context) => locator<AuthenticationService>().userController.stream,
      child: WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Laravel Forge',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          initialRoute: route.initialRoute,
          navigatorKey: navigatorKey,
          routes: route.Router.routes,
        ),
      ),
    );
  }
}
