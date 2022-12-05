import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_laravel/constants.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/authentication_service.dart';
import 'package:flutter_laravel/core/services/server_service_service.dart';
import 'package:flutter_laravel/core/viewmodels/Menu_bar_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/main.dart';
import 'package:flutter_laravel/server_types.dart';
import 'package:flutter_laravel/ui/components/separator.dart';
import 'package:flutter_laravel/ui/views/base_view.dart';
import 'package:provider/provider.dart';

class MyMenuBarApp extends StatefulWidget {
  final Widget body;
  const MyMenuBarApp(this.body, {super.key});

  @override
  State<MyMenuBarApp> createState() => _MyMenuBarAppState();
}

class _MyMenuBarAppState extends State<MyMenuBarApp> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>(
      initialData: false,
      create: (context) => locator<ServerService>().serverData.stream,
      child: StreamBuilder(
        stream: locator<ServerService>().serverData.stream,
        builder: (c,data) {

          return PlatformMenuBar(
            menus: <MenuItem>[
              if((locator<ServerService>().servers!= null &&locator<ServerService>().servers.isNotEmpty))
                PlatformMenu(
                  label: 'Servers',
                  menus: <MenuItem>[
                    PlatformMenuItemGroup(
                      members: <MenuItem>[
                        ...locator<ServerService>().servers.map(
                              (Server server) => PlatformMenu(
                            label: server.name!,
                            menus: <MenuItem>[
                              PlatformMenuItemGroup(
                                members: <MenuItem>[
                                  PlatformMenuItem(
                                    label: 'Reboot Server',
                                    onSelected: () {
                                      showCustomAlertDialog(navigatorKey.currentContext!, "Are you sure you want to reboot Server ?", () {
                                        Navigator.of(navigatorKey.currentContext!).pop();
                                        // locator<ServerService>().rebootServer(server);
                                      });
                                    },
                                  ),
                                  if (ServerTypes.hasPhp.contains(server.type!.toLowerCase()))
                                    PlatformMenuItem(
                                      label: 'Reboot PHP',
                                      onSelected: () {
                                        showCustomAlertDialog(navigatorKey.currentContext!, "Are you sure you want to reboot PHP ?", () {
                                          Navigator.of(navigatorKey.currentContext!).pop();
                                          // locator<ServerService>().rebootPHP(server);
                                        });
                                      },
                                    ),
                                  if (ServerTypes.hasDatabase.contains(server.type!.toLowerCase()) &&
                                      server.database_type!.toLowerCase().contains("mysql"))
                                    PlatformMenuItem(
                                      label: 'Reboot MySQL',
                                      onSelected: () {
                                        showCustomAlertDialog(navigatorKey.currentContext!, "Are you sure you want to reboot MySQL ?", () {
                                          Navigator.of(navigatorKey.currentContext!).pop();
                                          // locator<ServerService>().rebootMysql(server);
                                        });
                                      },
                                    ),
                                  if (ServerTypes.hasNginx.contains(server.type!.toLowerCase()))
                                    PlatformMenuItem(
                                      label: 'Reboot Nginx',
                                      onSelected: () {
                                        showCustomAlertDialog(navigatorKey.currentContext!, "Are you sure you want to reboot Nginx ?", () {
                                          Navigator.of(navigatorKey.currentContext!).pop();
                                          // locator<ServerService>().rebootNginx(server);
                                        });
                                      },
                                    ),
                                  if (ServerTypes.hasDatabase.contains(server.type!.toLowerCase()) &&
                                      server.database_type!.toLowerCase().contains("postgres"))
                                    PlatformMenuItem(
                                      label: 'Reboot Postgres',
                                      onSelected: () {
                                        showCustomAlertDialog(navigatorKey.currentContext!, "Are you sure you want to reboot Postgres ?", () {
                                          Navigator.of(navigatorKey.currentContext!).pop();
                                          // locator<ServerService>().rebootPostgres(server);
                                        });
                                      },
                                    ),
                                ],
                              ),
                              if(ServerTypes.hasSites.contains(server.type!.toLowerCase()))
                                PlatformMenuItemGroup(
                                  members: <MenuItem>[
                                    ...server.getSites!.map(
                                          (Site? e) => PlatformMenu(
                                        label: e!.name!,
                                        menus: <MenuItem>[
                                          PlatformMenuItemGroup(
                                            members: [
                                              PlatformMenuItem(
                                                label: 'Visit Site',
                                                onSelected: () {},
                                              ),
                                            ],
                                          ),
                                          if(ServerTypes.loadBalancer != server.type!.toLowerCase())
                                            PlatformMenuItemGroup(
                                              members: [
                                                PlatformMenuItem(
                                                  label: 'Show Deployments',
                                                  onSelected: () {},
                                                ),
                                              ],
                                            ),
                                          if(ServerTypes.loadBalancer != server.type!.toLowerCase())
                                            PlatformMenuItemGroup(
                                              members: [
                                                PlatformMenuItem(
                                                  label: 'Deploy Site',
                                                  onSelected: () {},
                                                ),
                                              ],
                                            ),
                                          if(ServerTypes.loadBalancer != server.type!.toLowerCase() || ServerTypes.hasNginx.contains(server.type!.toLowerCase()))
                                            PlatformMenuItemGroup(
                                              members: [
                                                if (ServerTypes.hasNginx.contains(server.type!.toLowerCase()))
                                                  PlatformMenuItem(
                                                    label: 'Nginx Configuration',
                                                    onSelected: () {},
                                                  ),
                                                if(ServerTypes.loadBalancer != server.type!.toLowerCase())
                                                  PlatformMenuItem(
                                                    label: 'Edit .env',
                                                    onSelected: () {},
                                                  ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              if(ServerTypes.hasDatabase.contains(server.type!.toLowerCase()))
                                PlatformMenuItemGroup(
                                  members: <MenuItem>[
                                    ...server.getDatabases!.map(
                                          (DatabaseModel? e) =>    PlatformMenuItem(
                                            label: e!.name!,
                                            onSelected: () {},
                                          ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
            body: widget.body,
          );
        }
      ),
    );
  }

  showCustomDialog({
    required BuildContext context,
    VoidCallback? onAddDatabasePressed,
    VoidCallback? onAddDatabaseUserPressed,
    VoidCallback? onManageDatabasePasswordPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Color(0xff1e272c),
              child: const Text(
                "Database Settings",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: onAddDatabasePressed,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add Database",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            separator(),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: onAddDatabaseUserPressed,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add Database User",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            separator(),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: onManageDatabasePasswordPressed,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Manage Main Database Password",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            separator(),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showEditDatabaseDialog({
    required BuildContext context,
    required String databaseName,
    required VoidCallback? onDeleteDatabasePressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Color(0xff1e272c),
              child: Text(
                databaseName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                onPressed: onDeleteDatabasePressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.redAccent.withOpacity(0.25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Delete Database",
                          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            separator(),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCustomAlertDialog(BuildContext context, String title, VoidCallback onPressed, {Color? color,String? okText}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark(),
        child: CupertinoAlertDialog(
          title: Text(title,style: TextStyle(color: color),),
          actions: [
            CupertinoDialogAction(
                child: Text("Cancel"),
                textStyle: TextStyle(fontSize: 14),
                onPressed: () => Navigator.pop(context)),
            CupertinoDialogAction(child: Text(okText??'Ok'), onPressed: onPressed, textStyle: TextStyle(fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }

}
