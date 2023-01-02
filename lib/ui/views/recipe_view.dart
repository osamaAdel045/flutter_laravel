import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/recipe.dart';
import 'package:flutter_laravel/core/viewmodels/recipe_model.dart';
import 'package:flutter_laravel/ui/components/separator.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/shared/ui_helpers.dart';
import 'package:flutter_laravel/ui/widgets/editor.dart';

import 'base_view.dart';

class RecipeView extends StatefulWidget {
  final Recipe? recipe;

  const RecipeView._({Key? key, this.recipe}) : super(key: key);

  const factory RecipeView.edit({Key? key, required Recipe recipe}) = RecipeView._;

  const factory RecipeView.add({Key? key}) = RecipeView._;

  @override
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<RecipeModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) => _RecipeBody(
        recipe: widget.recipe,
        model: model,
      ),
    );
  }
}

class _RecipeBody extends StatefulWidget {
  const _RecipeBody({
    Key? key,
    required this.recipe,
    required this.model,
  }) : super(key: key);

  final Recipe? recipe;
  final RecipeModel model;

  @override
  State<_RecipeBody> createState() => _RecipeBodyState();
}

class _RecipeBodyState extends State<_RecipeBody> {
  late final TextEditingController scriptController;
  late final TextEditingController nameController;
  late final TextEditingController userController;

  String? name;
  String? user;
  String? script;

  RecipeAction action = RecipeAction.view;

  @override
  void initState() {
    action = widget.recipe == null ? RecipeAction.add : RecipeAction.view;
    final oldRecipe = widget.recipe;
    if (oldRecipe != null) {
      name = oldRecipe.name ?? '';
      user = oldRecipe.user ?? '';
      script = oldRecipe.script ?? '';
    }
    scriptController = TextEditingController(text: script);
    scriptController.addListener(() {
      script = scriptController.text;
    });
    nameController = TextEditingController(text: name);
    nameController.addListener(() {
      name = nameController.text;
    });
    userController = TextEditingController(text: user);
    userController.addListener(() {
      user = userController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    scriptController.dispose();
    nameController.dispose();
    userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(
          widget.recipe?.name ?? 'Add new Recipe',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (action == RecipeAction.view)
            IconButton(
              onPressed: () {
                setState(() {
                  action = RecipeAction.edit;
                });
              },
              icon: const Icon(Icons.edit),
            ),
          if (action == RecipeAction.view)
            IconButton(
              onPressed: () async {
                final b = await showConfirmDeleteDialog();
                if (b == true) {
                  await widget.model.deleteRecipe(widget.recipe!.id!);
                  if (mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              icon: const Icon(Icons.delete),
            ),
          if (action == RecipeAction.edit || action == RecipeAction.add)
            IconButton(
              onPressed: () {
                switch (action) {
                  case RecipeAction.edit:
                    setState(() {
                      action = RecipeAction.view;
                      final oldRecipe = widget.recipe!;
                      name = oldRecipe.name ?? '';
                      user = oldRecipe.user ?? '';
                      script = oldRecipe.script ?? '';
                      scriptController.text = script ?? '';
                      nameController.text = name ?? '';
                      userController.text = user ?? '';
                    });
                    break;
                  case RecipeAction.add:
                    Navigator.of(context).pop();
                    break;
                  default:
                    break;
                }
              },
              icon: const Icon(Icons.close),
            ),
          if (action == RecipeAction.edit || action == RecipeAction.add)
            IconButton(
              onPressed: () async {
                if (name != null && user != null && script != null) {
                  switch (action) {
                    case RecipeAction.edit:
                      await widget.model.updateRecipe(widget.recipe!.id!, name!, user!, script!);
                      break;
                    case RecipeAction.add:
                      await widget.model.addRecipe(name!, user!, script!);
                      break;
                    default:
                      break;
                  }
                  if (mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              icon: const Icon(Icons.done),
            ),
        ],
      ),
      body: widget.model.state == ViewState.Busy
          ? loadingIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Name',
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                UIHelper.horizontalSpace(20),
                                Expanded(
                                  child: TextField(
                                    controller: nameController,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      filled: action == RecipeAction.edit || action == RecipeAction.add,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    readOnly: action != RecipeAction.edit && action != RecipeAction.add,
                                    style:
                                        const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Separator(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'User',
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                UIHelper.horizontalSpace(20),
                                Expanded(
                                  child: TextField(
                                    controller: userController,
                                    readOnly: action != RecipeAction.edit && action != RecipeAction.add,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      filled: action == RecipeAction.edit || action == RecipeAction.add,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style:
                                        const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: editorColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(15),
                      child: Editor(
                        controller: scriptController,
                        nestedScroll: true,
                        readOnly: action != RecipeAction.edit && action != RecipeAction.add,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<bool?> showConfirmDeleteDialog() async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              textStyle: const TextStyle(fontSize: 14),
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              textStyle: const TextStyle(fontSize: 14),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

enum RecipeAction { view, edit, add }
