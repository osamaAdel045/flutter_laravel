import 'dart:async';


import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/deployment_model.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/services/api.dart';

import '../../locator.dart';
import 'base_model.dart';

class DeploymentsViewModel extends BaseModel {
  Api _api = locator<Api>();
  List<DeploymentModel> _deployments = <DeploymentModel>[];

  List<DeploymentModel> get deployments => _deployments;

  Future<List<DeploymentModel>?> getDeployments(String serverId, String siteId) async {
    setState(ViewState.Busy);
    _deployments = (await _api.getDeployments(serverId,siteId))!;
    setState(ViewState.Idle);
    return (await _api.getDeployments(serverId,siteId))!;
  }

  Future<String?> getDeploymentLog(String serverId, String siteId, String deploymentId) async {
    setState(ViewState.Busy);
    String? log;
    log = await _api.getDeploymentLog(serverId, siteId,deploymentId);
    setState(ViewState.Idle);
    return log;
  }
}
