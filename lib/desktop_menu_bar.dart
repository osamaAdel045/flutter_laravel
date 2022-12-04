import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/authentication_service.dart';
import 'package:flutter_laravel/core/services/server_service_service.dart';
import 'package:flutter_laravel/core/viewmodels/Menu_bar_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/main.dart';
import 'package:flutter_laravel/server_types.dart';
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
        builder: (context,data) {

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
                                    onSelected: () {},
                                  ),
                                  if (ServerTypes.hasPhp.contains(server.type!.toLowerCase()))
                                    PlatformMenuItem(
                                      label: 'Reboot PHP',
                                      onSelected: () {},
                                    ),
                                  if (ServerTypes.hasDatabase.contains(server.type!.toLowerCase()) &&
                                      server.database_type!.toLowerCase().contains("mysql"))
                                    PlatformMenuItem(
                                      label: 'Reboot MySQL',
                                      onSelected: () {},
                                    ),
                                  if (ServerTypes.hasNginx.contains(server.type!.toLowerCase()))
                                    PlatformMenuItem(
                                      label: 'Reboot Nginx',
                                      onSelected: () {},
                                    ),
                                  if (ServerTypes.hasDatabase.contains(server.type!.toLowerCase()) &&
                                      server.database_type!.toLowerCase().contains("postgres"))
                                    PlatformMenuItem(
                                      label: 'Reboot Postgres',
                                      onSelected: () {},
                                    ),
                                  PlatformMenuItem(
                                    label: 'Reboot',
                                    onSelected: () {},
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
}
