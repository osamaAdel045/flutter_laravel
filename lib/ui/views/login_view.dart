import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/viewmodels/login_model.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/shared/app_colors.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/shared/ui_helpers.dart';
import 'package:flutter_laravel/ui/widgets/login_header.dart';
import '../router.dart';
import 'base_view.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _controller = TextEditingController();
  bool changingRouteOnStart = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) async {
        var loginSuccess = await model.checkAuth();
        if (loginSuccess) {
          setState(() {
            changingRouteOnStart = true;
          });
          if (mounted) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        }
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: model.state == ViewState.Busy || changingRouteOnStart == true
            ? loadingIndicator()
            : Center(
                child: SizedBox(
                  width: 400,
                  child: Card(
                    elevation: 20,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UIHelper.verticalSpace(20),
                        LoginHeader(validationMessage: model.errorMessage, controller: _controller),
                        UIHelper.verticalSpace(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: model.state == ViewState.Busy
                              ? loadingIndicator()
                              : Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: MainButton(
                                    text: "Login",
                                    width: 100,
                                    onPressed: () async {
                                      var loginSuccess = await model.login(_controller.text);
                                      if (mounted && loginSuccess) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          Routes.home,
                                        );
                                      }
                                    },
                                  ),
                                ),
                        ),
                        UIHelper.verticalSpace(20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
