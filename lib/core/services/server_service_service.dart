import 'dart:async';
import 'package:flutter_laravel/core/models/server.dart';

import '../models/user.dart';
import '../../locator.dart';
import 'api.dart';

class ServerService {
  Api _api = locator<Api>();

  StreamController<bool> serverData = StreamController<bool>();
  List<Server> servers = [];

}
