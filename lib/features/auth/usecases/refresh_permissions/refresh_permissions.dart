import '../../../../../core/result.dart';
import '../../../../../core/usecase.dart';
import '../../models/permission_set.dart';
import '../../repositories/permission_repository.dart';

part 'refresh_permissions_param.dart';

class RefreshPermissions
    implements UseCase<Result<PermissionSet>, RefreshPermissionsParams> {
  final PermissionRepository _repo = PermissionRepository();

  @override
  Future<Result<PermissionSet>> call(RefreshPermissionsParams p) async {
    final res = await _repo.fetch(ifNoneMatchVersion: p.currentVersion);
    if (res.isSuccess) {
      await _repo.persistCache(res.resultValue!, userId: p.userId);
    }
    return res;
  }
}
