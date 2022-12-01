import 'dart:async';


import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/services/api.dart';

import '../../locator.dart';
import 'base_model.dart';

class RecipesModel extends BaseModel {
  Api _api = locator<Api>();
  List<Recipe> _recipes =  <Recipe>[];

  List<Recipe> get recipes => _recipes;

  Future getRecipes() async {
    setState(ViewState.Busy);
    _recipes = (await _api.getRecipes())!;
    setState(ViewState.Idle);
  }
}
