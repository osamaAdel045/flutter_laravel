import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget?child) builder;
  final Function(T) onModelReady;

  BaseView({required this.builder, required this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {

    print('initState');
    widget.onModelReady(model);
    // if (widget.onModelReady != null) {
    // }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
