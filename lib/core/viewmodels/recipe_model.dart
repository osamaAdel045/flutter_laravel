import 'dart:async';

import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/services/api.dart';
import 'package:flutter_laravel/ui/components/snack.dart';

import '../../locator.dart';
import 'base_model.dart';

class RecipeModel extends BaseModel {
  final Api _api = locator<Api>();

  Recipe? recipe;

  Future<bool> updateRecipe(int id, String name, String user, String script) async {
    bool succeed = false;
    try {
      setState(ViewState.Busy);
      final r = await _api.updateRecipe(id, name, user, script);
      if (r != null) {
        recipe = r;
        succeed = true;
      }
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      succeed = false;
    }
    Snack.show(succeed ? 'Updated recipe successfully' : 'Failed to update recipe', succeed);
    return succeed;
  }

  Future<bool> addRecipe(String name, String user, String script) async {
    bool succeed = false;
    try {
      setState(ViewState.Busy);
      final r = await _api.addRecipe(name, user, script);
      if (r != null) {
        recipe = r;
        succeed = true;
      }
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      succeed = false;
    }
    Snack.show(succeed ? 'Added recipe successfully' : 'Failed to add recipe', succeed);
    return succeed;
  }

  Future<bool> deleteRecipe(int id) async {
    bool succeed = false;
    try {
      setState(ViewState.Busy);
      final b = await _api.deleteRecipe(id);
      if (b) {
        succeed = true;
      }
      setState(ViewState.Idle);
    } catch (e, s) {
      print(e);
      print(s);
      succeed = false;
    }
    Snack.show(succeed ? 'Deleted recipe successfully' : 'Failed to delete recipe' , succeed);
    return succeed;
  }
}
