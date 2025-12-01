import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/styles/theme.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/product_list_screen.dart';
import 'package:upgrader/upgrader.dart';

import 'core/routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(context);

    return MaterialApp(
      title: 'HRIS Pentamoo',
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      // routerConfig: router,
      home: ProductListScreen(),
      builder: (context, child) {
        return UpgradeAlert(
          navigatorKey: router.routerDelegate.navigatorKey,
          child: child,
        );
      },
    );
  }
}
