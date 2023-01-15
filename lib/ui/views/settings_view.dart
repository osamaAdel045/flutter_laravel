import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/viewmodels/settings_model.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/shared/ui_helpers.dart';
import 'package:flutter_laravel/ui/show_notification/setup_notifications.dart';

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
          : SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: SizedBox(
                  width: 800,
                  child: Card(
                    elevation: 20,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Token:-',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          UIHelper.verticalSpaceSmall(),
                          SelectableText(model.token!),
                          UIHelper.verticalSpaceSmall(),
                          const SizedBox(height: 10),
                          MainButton(
                            text: "Logout",
                            onPressed: () async {
                              await model.logout();
                              SetupFCM.logout();
                              currentIndex = 0;
                              if (mounted) {
                                Navigator.of(context, rootNavigator: true).pushReplacementNamed(Routes.login);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
