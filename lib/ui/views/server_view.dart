import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/database_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/authentication_service.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/server_types.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/components/separator.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';

import 'base_view.dart';

class ServerView extends StatefulWidget {
  final Server? server;

  const ServerView({Key? key, this.server}) : super(key: key);

  @override
  _ServerViewState createState() => _ServerViewState();
}

class _ServerViewState extends State<ServerView> {
  List<Site> _sites = <Site>[];
  List<DatabaseModel> _databaseModels = <DatabaseModel>[];

  @override
  Widget build(BuildContext context) {
    print("widget.server!");
    print(widget.server!.type!);
    return BaseView<ServersViewModel>(
      onModelReady: (model) async {
        if (ServerTypes.hasSites.contains(widget.server!.type!.toLowerCase())) {
          _sites = (await model.getSites(widget.server))!;
        }
        if (ServerTypes.hasDatabase.contains(widget.server!.type!.toLowerCase())) {
          _databaseModels = (await model.getDatabases(widget.server))!;
        }
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text(
            widget.server!.name!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: model.state == ViewState.Busy
            ? loadingIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Commands',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.all(5.0),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'IP',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.server!.ip_address!,
                                    style:
                                        const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Separator(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Region',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.server!.region!,
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Commands',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (ServerTypes.hasPhp.contains(widget.server!.type!.toLowerCase()))
                      item('Reboot PHP', () async {
                        showCustomAlertDialog(context, "Are you sure you want to reboot PHP ?", () {
                          Navigator.of(context).pop();
                          // model.rebootPHP(widget.server!);
                        });
                      }),
                    if (ServerTypes.hasDatabase.contains(widget.server!.type!.toLowerCase()) &&
                        widget.server!.database_type!.toLowerCase().contains("mysql"))
                      item('Reboot MySQL', () {
                        showCustomAlertDialog(context, "Are you sure you want to reboot MySQL ?", () {
                          Navigator.of(context).pop();
                          // model.rebootMysql(widget.server!);
                        });
                      }),
                    if (ServerTypes.hasNginx.contains(widget.server!.type!.toLowerCase()))
                      item('Reboot Nginx', () {
                        showCustomAlertDialog(context, "Are you sure you want to reboot Nginx ?", () {
                          Navigator.of(context).pop();
                          // model.rebootNginx(widget.server!);
                        });
                      }),
                    if (ServerTypes.hasDatabase.contains(widget.server!.type!.toLowerCase()) &&
                        widget.server!.database_type!.toLowerCase().contains("postgres"))
                      item('Reboot Postgres', () {
                        showCustomAlertDialog(context, "Are you sure you want to reboot Postgres ?", () {
                          Navigator.of(context).pop();
                          // model.rebootPostgres(widget.server!);
                        });
                      }),
                    item('Reboot Server', () {
                      showCustomAlertDialog(context, "Are you sure you want to reboot Server ?", () {
                        Navigator.of(context).pop();
                        // model.rebootServer(widget.server!);
                      });
                    }),
                    item('Open SSH Client', () {}),
                    const SizedBox(
                      height: 15,
                    ),
                    if (ServerTypes.hasSites.contains(widget.server!.type!.toLowerCase())) sites(),
                    if (ServerTypes.hasDatabase.contains(widget.server!.type!.toLowerCase())) databases(model),
                  ],
                ),
              ),
      ),
    );
  }

  Widget item(String name, VoidCallback? onPressed) {
    return MainButton(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.start,
      text: name,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.green,
      overlayColor: Colors.green.withOpacity(0.5),
    );
  }

  Widget sites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: const Text(
            'Sites',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        ListView.builder(
          itemCount: _sites.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            print(_sites[i]);
            return item(
                _sites[i].name!,
                () => Navigator.pushNamed(
                      context,
                      Routes.site,
                      arguments: [_sites[i], widget.server],
                    ));
          },
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget databases(ServersViewModel serversModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Databases',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () {
                    showCustomDialog(
                      onAddDatabasePressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Routes.addDatabase,
                            arguments: [false, widget.server] // isDatabaseUser value is false
                            );
                      },
                      onAddDatabaseUserPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Routes.addDatabase,
                            arguments: [true, widget.server] // isDatabaseUser value is true
                            );
                      },
                      onManageDatabasePasswordPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Routes.changeDatabasePassword,
                            arguments: widget.server // isDatabaseUser value is true
                            );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 30,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        ListView.builder(
          itemCount: _databaseModels.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            print(_databaseModels[i]);
            return databaseIem(context, _databaseModels[i], serversModel);
          },
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget databaseIem(
    BuildContext context,
    DatabaseModel databaseModel,
    ServersViewModel serversModel,
  ) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    databaseModel.name!,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    databaseModel.status!,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Created at',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    databaseModel.created_at!,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Created at',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    databaseModel.created_at!,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MainButton(
              text: "Edit",
              onPressed: () async {
                showEditDatabaseDialog(
                  databaseName: databaseModel.name!,
                  onDeleteDatabasePressed: () {
                    Navigator.of(context).pop();
                    showCustomAlertDialog(
                      context,
                      "Are you sure you want to delete ${databaseModel.name} ?",
                          () {
                        Navigator.of(context).pop();
                        // serversModel.deleteDatabase((widget.server!.id).toString(),(databaseModel.id).toString());

                      },
                      color: Colors.red,
                      okText: "Delete",
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  showCustomDialog({
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
              color: Colors.green,
              child: const Text(
                "Database Settings",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            MainButton(
              text: "Add Database",
              fontWeight: FontWeight.w500,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: onAddDatabasePressed,
            ),
            const Separator(),
            MainButton(
              text: "Add Database User",
              fontWeight: FontWeight.w500,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: onAddDatabaseUserPressed,
            ),
            const Separator(),
            MainButton(
              text: "Manage Main Database Password",
              fontWeight: FontWeight.w500,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: onManageDatabasePasswordPressed,
            ),
            const Separator(),
            MainButton(
              text: "Cancel",
              fontWeight: FontWeight.w500,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  showEditDatabaseDialog({
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
            const Separator(),
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

  showCustomAlertDialog(BuildContext context, String title, VoidCallback onPressed, {Color? color, String? okText}) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(dialogTheme: ThemeData.dark().dialogTheme.copyWith()),
        child: CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(color: color),
          ),
          actions: [
            CupertinoButton(
              child: Text("Cancel", style: TextStyle(fontSize: 14)),
              color: ThemeData.dark().backgroundColor,
              padding: EdgeInsets.all(2),
              onPressed: () => Navigator.pop(context),
              borderRadius: BorderRadius.zero,
            ),
            CupertinoButton(
              child: Text(okText ?? 'Ok', style: TextStyle(fontSize: 14, color: color)),
              color: ThemeData.dark().backgroundColor,
              padding: EdgeInsets.all(2),
              onPressed: onPressed,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      ),
    );
  }
}
