import 'package:flutter/material.dart';
import 'package:flutter_laravel/constants.dart';

class Snack extends SnackBar {
  static show(String content, bool succeed) {
    if (navigatorKey.currentContext == null) {
      print('navigatorKey context is null');
      return;
    }
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      Snack(
        content: content,
        succeed: succeed,
      ),
    );
  }

  Snack({
    Key? key,
    required String content,
    required bool succeed,
  }) : super(
          key: key,
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          elevation: 8,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          backgroundColor: succeed ? Colors.green : Colors.red.shade900,
          content: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  succeed ? Icons.done : Icons.close,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  content,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
}
