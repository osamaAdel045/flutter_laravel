import 'dart:async';

import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/services/api.dart';

import '../../locator.dart';
import 'base_model.dart';

class RecipeModel extends BaseModel {
  final Api _api = locator<Api>();

  Recipe? recipe;

  Future updateRecipe(int id, String name, String user, String script) async {
    setState(ViewState.Busy);
    recipe = (await _api.updateRecipe(id, name, user, script))!;
    setState(ViewState.Idle);
  }

  Future addRecipe(String name, String user, String script) async {
    setState(ViewState.Busy);
    recipe = (await _api.addRecipe(name, user, script))!;
    setState(ViewState.Idle);
  }

  Future deleteRecipe(int id) async {
    setState(ViewState.Busy);
    await _api.deleteRecipe(id);
    setState(ViewState.Idle);
  }
}
