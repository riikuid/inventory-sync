import '../../../../core/usecase.dart';
import '../../models/permission_set.dart';
import '../../repositories/permission_repository.dart';

part 'bootstrap_permissions_params.dart';

class BootstrapPermissions
    implements UseCase<PermissionSet, BootstrapPermissionsParams> {
  final PermissionRepository _repo = PermissionRepository();

  BootstrapPermissions();

  @override
  Future<PermissionSet> call(BootstrapPermissionsParams p) async {
    // 1) mulai dari seed (jika ada), else dari cache, else kosong
    PermissionSet current =
        p.seed ??
        (await _repo.readCache(userId: p.userId)) ??
        const PermissionSet({});

    // 2) optional refresh? (default true)
    if (p.refreshFromServer) {
      final fetched = await _repo.fetch(ifNoneMatchVersion: current.version);
      if (fetched.isSuccess) {
        current = fetched.resultValue!;
        await _repo.persistCache(current, userId: p.userId);
      }
      // kalau gagal, tetap pakai current (seed/cache) agar UI tidak blank
    }

    return current;
  }
}
