import 'package:flutter/material.dart';
import 'package:flutter_laravel/ui/views/recipes_view.dart';
import 'package:flutter_laravel/ui/views/servers_view.dart';
import 'package:flutter_laravel/ui/views/settings_view.dart';

int currentIndex = 0;

class MainView extends StatefulWidget {
  @override
  _ServersViewState createState() => _ServersViewState();
}

class _ServersViewState extends State<MainView> {
  get _tabName {
    switch (currentIndex) {
      case 0:
        return 'Servers';
      case 1:
        return 'Recipes';
      case 2:
        return 'Settings';
    }
  }

  get _getPage {
    switch (currentIndex) {
      case 0:
        return ServersView();
      case 1:
        return RecipesView();
      case 2:
        return SettingsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title:  Text(
          "Laravel Forge - $_tabName",
          style:  TextStyle(color: Colors.white),
        ),
      ),
      body: _getPage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Servers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
