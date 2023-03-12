import 'dart:async';

import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/ui/components/snack.dart';

import '../../locator.dart';
import 'base_model.dart';

class RecipesModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Recipe> _recipes = <Recipe>[];

  List<Recipe> get recipes => _recipes;

  Future getRecipes() async {
    try {
      setState(ViewState.Busy);
      final r = await _api.getRecipes();
      if (r == null) {
        Snack.show('Failed to get recipes', false);
      }
      _recipes = r ?? [];
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      Snack.show('Failed to get recipes', false);
    }
  }
}
