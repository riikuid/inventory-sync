import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/permission_set.dart';
import '../../../usecases/bootstrap_permissions/bootstrap_permissions.dart';
import '../../../usecases/refresh_permissions/refresh_permissions.dart';
import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final BootstrapPermissions _bootstrap;
  final RefreshPermissions _refresh;

  PermissionCubit({
    BootstrapPermissions? bootstrap,
    RefreshPermissions? refresh,
  }) : _bootstrap = bootstrap ?? BootstrapPermissions(),
       _refresh = refresh ?? RefreshPermissions(),
       super(const PermissionState(set: PermissionSet({})));

  // Dipanggil saat:
  // - setelah login sukses (pakai seed dari payload login)
  // - saat app start (tanpa seed; akan pakai cache)
  Future<void> bootstrap({
    PermissionSet? seed,
    String? userId,
    bool refreshFromServer = true,
  }) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await _bootstrap(
        BootstrapPermissionsParams(
          seed: seed,
          userId: userId,
          refreshFromServer: refreshFromServer,
        ),
      );
      emit(state.copyWith(set: result, loading: false, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// Dipanggil saat: pull-to-refresh, setelah 403, atau schedule periodik
  Future<void> refresh({String? userId}) async {
    emit(state.copyWith(loading: true, error: null));
    final res = await _refresh(
      RefreshPermissionsParams(
        currentVersion: state.set.version,
        userId: userId,
      ),
    );
    if (res.isSuccess) {
      emit(state.copyWith(set: res.resultValue!, loading: false, error: null));
    } else {
      emit(state.copyWith(loading: false, error: res.errorMessage));
    }
  }

  // Helper untuk UI
  bool can(String key) => state.set.has(key);
  bool canAny(Iterable<String> keys) => state.set.anyOf(keys);
  bool canAll(Iterable<String> keys) => state.set.allOf(keys);
}
