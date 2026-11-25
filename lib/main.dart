import 'package:flutter/material.dart';
import 'package:jordan/core/app_theme.dart';
import 'package:jordan/screens/dashboard.dart';
import 'package:jordan/services/app_state.dart';

void main() {
  runApp(MyApp(appState: AppState()));
}

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Flow',
      theme: AppTheme.lightTheme,
      home: Dashboard(appState: appState),
    );
  }
}
