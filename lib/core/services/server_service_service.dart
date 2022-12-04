import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/viewmodels/base_model.dart';
import 'package:flutter_laravel/ui/components/separator.dart';

import '../models/user.dart';
import '../../locator.dart';
import 'api.dart';

class ServerService extends BaseModel{
  Api _api = locator<Api>();

  StreamController<bool> serverData = StreamController<bool>();
  List<Server> servers = [];



}
