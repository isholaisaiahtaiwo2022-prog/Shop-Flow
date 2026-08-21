import 'package:flutter/material.dart';

class AppUtils {
  AppUtils._();

  static void showsnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
