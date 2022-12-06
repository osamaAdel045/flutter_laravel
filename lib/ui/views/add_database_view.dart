import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/viewmodels/database_view_model.dart';
import 'package:flutter_laravel/core/viewmodels/login_model.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/shared/app_colors.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/shared/text_styles.dart';
import 'package:flutter_laravel/ui/widgets/login_header.dart';
import '../router.dart';
import 'base_view.dart';

class AddDatabaseView extends StatefulWidget {
  final bool isDatabaseUser;
  final Server server;

  AddDatabaseView({required this.isDatabaseUser, required this.server});

  @override
  _AddDatabaseViewState createState() => _AddDatabaseViewState();
}

class _AddDatabaseViewState extends State<AddDatabaseView> {
  final TextEditingController _databaseNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<DatabaseViewModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Database",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: backgroundColor,
        body: model.state == ViewState.Busy
            ? loadingIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 25,
                    ),
                    textField(_databaseNameController, "Database name", false),
                    if (widget.isDatabaseUser) textField(_userNameController, "User name", false),
                    if (widget.isDatabaseUser) textField(_passwordController, "Password", true),
                    const SizedBox(
                      height: 5,
                    ),
                    model.state == ViewState.Busy
                        ? loadingIndicator()
                        : MainButton(
                            margin: const EdgeInsets.all(20),
                            text: "Add",
                            onPressed: () async {
                              if (widget.isDatabaseUser) {
                                // var addDatabase = await model.addDatabase(
                                //     (widget.server.id!).toString(), _databaseNameController.text);
                                Navigator.of(context).pop(true);
                              } else {
                                // var addDatabase = await model.addDatabaseUser(
                                //   (widget.server.id!).toString(),
                                //   _databaseNameController.text,
                                //   _userNameController.text,
                                //   _passwordController.text,
                                // );
                                Navigator.of(context).pop(true);
                              }
                            },
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String hint, bool password) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      height: 50.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
          decoration: InputDecoration.collapsed(hintText: hint), controller: controller, obscureText: password),
    );
  }
}
