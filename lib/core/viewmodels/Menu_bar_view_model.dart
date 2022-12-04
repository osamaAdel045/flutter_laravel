import 'package:flutter/widgets.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/core/viewmodels/base_model.dart';
import 'package:flutter_laravel/locator.dart';

class MenuBarViewModel extends BaseModel {
  Api _api = locator<Api>();
  List<Server> _servers = <Server>[];

  List<Server> get servers => _servers;

}
