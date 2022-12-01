import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/viewmodels/login_model.dart';
import 'package:flutter_laravel/ui/shared/app_colors.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/widgets/login_header.dart';
import '../router.dart';
import 'base_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
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
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: model.state == ViewState.Busy || changingRouteOnStart == true
            ? loadingIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginHeader(validationMessage: model.errorMessage, controller: _controller),
                  model.state == ViewState.Busy
                      ? loadingIndicator()
                      : TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),overlayColor: MaterialStateProperty.all(Colors.blueGrey),),
                          child: const Text(
                            'Login',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            var loginSuccess = await model.login(_controller.text);
                            if (loginSuccess) {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.home,
                              );
                            }
                          },
                        )
                ],
              ),
      ),
    );
  }
}
