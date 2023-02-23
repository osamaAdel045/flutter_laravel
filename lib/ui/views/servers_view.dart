import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/locator.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'base_view.dart';

class ServersView extends StatefulWidget {
  @override
  _ServersViewState createState() => _ServersViewState();
}

class _ServersViewState extends State<ServersView> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showCustomDialog(context: context);
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: BaseView<ServersViewModel>(
        onModelReady: (model) => model.getServers(),
        builder: (context, model, child) => model.state == ViewState.Busy
            ? loadingIndicator()
            : ListView(
                children: List.generate(
                  model.servers.length,
                  (i) => ServerCard(
                    model: model,
                    server: model.servers[i],
                  ),
                ),
              ),
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
                "Preferences",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TabBar(
              controller: tabController,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.green,
              overlayColor: MaterialStateProperty.all(Colors.grey.shade300),
              tabs: const [
                Tab(
                  child: Text(
                    "Api Key",
                  ),
                ),
                Tab(
                  child: Text(
                    "General",
                  ),
                ),
                Tab(
                  child: Text(
                    "Notifications",
                  ),
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Center(child: Text("Api Key")),
                  Center(child: Text("General")),
                  Center(child: Text("Notifications")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerCard extends StatefulWidget {
  final Server? server;
  final ServersViewModel? model;

  ServerCard({this.server, this.model});

  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  bool _serverRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            color: Color(0xffebeced),
            child: Row(
              children: <Widget>[
                if (_serverRefreshing == false) ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Active"),
                  ),
                ],
                if (_serverRefreshing)
                  Container(
                    width: IconTheme.of(context).size,
                    height: IconTheme.of(context).size,
                    child: CircularProgressIndicator(),
                  ),
                Expanded(
                  child: Container(),
                ),
                PopupMenuButton(
                  onSelected: (result) async {
                    switch (result) {
                      case 0:
                        setState(() {
                          _serverRefreshing = true;
                        });
                        await widget.model?.refreshServer(widget.server!);
                        setState(() {
                          _serverRefreshing = false;
                        });
                        break;
                      case 1:
                        widget.model?.rebootServer(widget.server);
                        break;
                      case 2:
                        Navigator.pushNamed(
                          context,
                          Routes.server,
                          arguments: widget.server,
                        );
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text("Refresh"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.settings_backup_restore,
                                color: Colors.red,
                              ),
                            ),
                            Text("Reboot"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.apps,
                                color: Colors.green,
                              ),
                            ),
                            Text("Manage"),
                          ],
                        ),
                      ),
                    ];
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              children: <Widget>[
                ServerCardInfo(
                  'Name',
                  Text(
                    widget.server!.name!,
                    style: TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'Region',
                  Text(
                    widget.server!.region!,
                    style: TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'Size',
                  Text(
                    widget.server!.size!,
                    style: TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  'PHP Version',
                  Text(
                    widget.server!.php_version!,
                    style: TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                  "IP Address",
                  Text(
                    widget.server!.ip_address!,
                    style: TextStyle(
                      color: Color(0Xff424c54),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ServerCardInfo(
                    "Connection",
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Text(
                          "Successful",
                          style: TextStyle(
                            color: Color(0Xff424c54),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ServerCardInfo extends StatelessWidget {
  final String title;
  final Widget child;

  ServerCardInfo(this.title, this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Color(0Xff424c54),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Container()),
          child,
        ],
      ),
    );
  }
}
