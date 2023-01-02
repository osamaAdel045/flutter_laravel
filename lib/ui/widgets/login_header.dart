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
      Text('Login', style: headerStyle),
      UIHelper.verticalSpaceMedium(),
      Text('Enter Laravel Forge API Token', style: subHeaderStyle),
      LoginTextField(controller!),
      this.validationMessage != null
          ? Text(validationMessage!, style: TextStyle(color: Colors.red))
          : Container()
    ]);
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
