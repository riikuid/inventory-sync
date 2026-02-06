import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/app_root.dart';
import 'package:inventory_sync_apps/core/routes/navigation_helper.dart';
import 'package:inventory_sync_apps/core/styles/theme.dart';
import 'package:upgrader/upgrader.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // final router = buildRouter(context);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: 'MP Inventory Apps',

      theme: lightThemeData,
      themeMode: ThemeMode.light,

      home: AppRoot(),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: UpgradeAlert(child: child),
        );
      },
    );
  }
}
