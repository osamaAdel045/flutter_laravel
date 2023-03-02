import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/viewmodels/recipes_model.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';

import 'base_view.dart';

class RecipesView extends StatefulWidget {
  @override
  _RecipesViewState createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<RecipesModel>(
      onModelReady: (model) => model.getRecipes(),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? loadingIndicator()
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final b = await Navigator.of(context).pushNamed(Routes.addRecipe);
                  if (b == true) {
                    model.getRecipes();
                  }
                },
                child: const Icon(Icons.add),
              ),
              body: ListView(
                children: List.generate(
                  model.recipes.length,
                  (i) => ListTile(
                    onTap: () async {
                      final recipe = model.recipes[i];
                      if (mounted) {
                        final b = await Navigator.of(context).pushNamed(Routes.recipe, arguments: recipe);
                        if (b == true) {
                          model.getRecipes();
                        }
                      }
                    },
                    title: Text("Name: ${model.recipes[i].name!}"),
                    subtitle: Text("User: ${model.recipes[i].user!}"),
                    trailing: IconButton(
                      onPressed: () async {
                        final recipe = model.recipes[i];
                        if (mounted) {
                          final b = await Navigator.of(context).pushNamed(Routes.recipe, arguments: recipe);
                          if (b == true) {
                            model.getRecipes();
                          }
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
