import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/viewmodels/settings_model.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/shared/ui_helpers.dart';

import '../router.dart';
import 'base_view.dart';
import 'main_view.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsModel>(
      onModelReady: (model) => model.getSettings(),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? loadingIndicator()
          : Column(
              children: <Widget>[
                Text('Token: ' + model.token!),
                UIHelper.verticalSpaceSmall(),
                const SizedBox(height: 10),
                MainButton(
                  text: "Logout",
                  onPressed: () async {
                    await model.logout();
                    currentIndex = 0;
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacementNamed(Routes.login);
                  },
                ),
              ],
            ),
    );
  }
}
