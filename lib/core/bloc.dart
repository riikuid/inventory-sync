import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';
import 'package:inventory_sync_apps/features/auth/presentations/blocs/permission_cubit/permission_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/sync/bloc/sync_cubit.dart';

import '../features/printer/bloc/printer_cubit.dart';
import '../features/sync/data/sync_repository.dart';

class BlocSetting {
  static List<BlocProvider> providers() {
    return [
      BlocProvider<AuthCubit>(
        create: (BuildContext context) =>
            AuthCubit(context.read<SyncRepository>()),
      ),
      BlocProvider<PermissionCubit>(
        create: (BuildContext context) => PermissionCubit(),
      ),
      BlocProvider<PrinterCubit>(create: (context) => PrinterCubit()..init()),
      BlocProvider<SyncCubit>(
        create: (context) => SyncCubit(context.read<SyncRepository>()),
      ),

      BlocProvider<ReceivingSessionCubit>(
        create: (context) => ReceivingSessionCubit(),
      ),

      // BlocProvider<RefreshLayoutCubit>(
      //   create: (BuildContext context) => RefreshLayoutCubit(),
      // ),
    ];
  }
}
