import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/app_root.dart';
import 'package:inventory_sync_apps/core/styles/theme.dart';
import 'package:upgrader/upgrader.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // final router = buildRouter(context);

    return MaterialApp(
      title: 'HRIS Pentamoo',
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      home: AppRoot(),
      builder: (context, child) {
        return UpgradeAlert(child: child);
      },
    );
  }
}
