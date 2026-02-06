import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:inventory_sync_apps/app_bloc_observer.dart';
import 'package:inventory_sync_apps/core/app_firebase.dart';
import 'package:inventory_sync_apps/features/sync/services/sync_service.dart';
import 'package:inventory_sync_apps/features/sync/data/sync_repository.dart';

import 'app.dart';
import 'core/bloc.dart';
import 'core/config.dart';
import 'core/db/app_database.dart';
import 'core/local_notification.dart';
import 'features/inventory/data/inventory_repository.dart';
import 'features/labeling/data/labeling_repository.dart';

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  // App Configuration
  Config().init();

  // await AppFirebase.init();

  final db = AppDatabase();

  Bloc.observer = AppBlocObserver();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>(create: (_) => db),
        RepositoryProvider<InventoryRepository>(
          create: (ctx) => InventoryRepository(ctx.read<AppDatabase>()),
        ),
        RepositoryProvider<InventoryRepository>(
          create: (ctx) => InventoryRepository(ctx.read<AppDatabase>()),
        ),
        RepositoryProvider<LabelingRepository>(
          create: (ctx) => LabelingRepository(ctx.read<AppDatabase>()),
        ),
        RepositoryProvider<SyncRepository>(
          create: (ctx) =>
              SyncRepository(db: ctx.read<AppDatabase>(), api: SyncService()),
        ),
        // nanti kalau ada SyncRepository, dsb, tinggal tambahkan di sini
      ],
      child: MultiBlocProvider(
        providers: BlocSetting.providers(),
        child: const App(),
      ),
    ),
  );

  // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   await localNotification.init();

  //   // Auto request (non-blocking terhadap splash):
  //   await AppFirebase.requestAndEnablePush();
  //   await localNotification.requestPermission();
  // });
}
