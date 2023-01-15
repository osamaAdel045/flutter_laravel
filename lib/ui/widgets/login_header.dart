import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/ui/shared/text_styles.dart';
import 'package:flutter_laravel/ui/shared/ui_helpers.dart';

class LoginHeader extends StatelessWidget {
  final TextEditingController? controller;
  final String? validationMessage;

  LoginHeader({@required this.controller, this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      LoginText(controller: controller),
      UIHelper.verticalSpaceMedium(),
      Text('Enter Laravel Forge API Token', style: subHeaderStyle),
      LoginTextField(controller!),
      this.validationMessage != null ? Text(validationMessage!, style: TextStyle(color: Colors.red)) : Container()
    ]);
  }
}

class LoginText extends StatefulWidget {
  const LoginText({Key? key, required this.controller}) : super(key: key);

  final TextEditingController? controller;

  @override
  State<LoginText> createState() => _LoginTextState();
}

class _LoginTextState extends State<LoginText> {
  Timer? timer;
  int count = 0;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final w = Text('Login', style: headerStyle);

    try {
      if (kDebugMode) {
        return GestureDetector(
          onTap: () {
            if (count >= 6) {
              timer?.cancel();
              widget.controller?.text =
                  'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOTExZjIzZTM3MzAzODA5M2MxNDVhMTBjZTcwMzQ4NzJkMzEzOGY3NjQ5NDE4MmQzMjY0N2NjYTY2OTE3YjE3ODllY2VjNzY1ZGIzMzI1ZTEiLCJpYXQiOjE2Njk1NTI2NjAuNzc1NjM2LCJuYmYiOjE2Njk1NTI2NjAuNzc1NjQsImV4cCI6MTk4NTE3MTg2MC43NzAzNDYsInN1YiI6IjE4MzQ1NCIsInNjb3BlcyI6W119.X49aCqBoHEYXo6JWXhftrilf9icgYLI4EpdSOh-f_0sHEQoovrWiIEax4HnzO8BctECQLEwwzu2_RVvk8o8dy8Rqq_vS7ZxFPypwRr85pHQEiYNkVb6XWT8aYJt7P5_uVJxFtWmmrtN7IDaLwNQp4t0sOQ-vcwI_pliV1FjOi9vhwr0kaqwDuPjLvMqaz5JdP4ICDjRy1xyFVIx39QOFXvJ2Y02I_l4l977jhhuUbmMhIVr3u7HBlLHieoxPrSV7rr1X2QQbvaOKX5hI3571nLtl1kWcEZuUnLcZtn7HihoQVFoOjd3_Ksix-R1-Pwyl8HfLxflEMIdew50pn0su6pgxfhyu9FjQqZvR6s7esbBp6cRoSf-hlZLTKtD79tG_rSw7TUHBYzNW3njb4Zq8rFBo3yDmL-0xFHwHjpoIp6gPpWY0jHdMaLT9OOi9bkBi27g5Zufcn0x7tTv4cD_1lxd-dHQDBM0-gVK-_5GbBKXAyDyQmMwXA5JAI-koPCLdLSUDcHPgyq9g7gFJrTTrvOrNzDGookJjoUVNx-C2QP34cwW_5NdbeTJlM3g5tDXUUjbOWY4CDhJd94_2qOEKMyFoKUbrGwrTu8JM16VxAmeltkLmzhCFqVsJFbgGg3Jjl2HK_gvEAh93b52umfDZo_f0nRHjtS9Vrh8y7b6376A';
              return;
            }
            count++;
            timer?.cancel();
            timer = Timer(Duration(seconds: 1), () {
              count = 0;
            });
          },
          child: w,
        );
      }
    } catch (e,s) {
      print(e);
      print(s);
    }

    return w;
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;

  LoginTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'API Token',
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
