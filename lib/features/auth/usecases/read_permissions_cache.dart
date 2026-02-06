import '../../../../core/usecase.dart';
import '../models/permission_set.dart';
import '../repositories/permission_repository.dart';

class ReadPermissionCache implements UseCase<PermissionSet?, String?> {
  final PermissionRepository _repo = PermissionRepository();

  @override
  Future<PermissionSet?> call(String? userId) =>
      _repo.readCache(userId: userId);
}
