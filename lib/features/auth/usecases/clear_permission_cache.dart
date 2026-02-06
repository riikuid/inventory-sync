import '../../../../core/usecase.dart';
import '../repositories/permission_repository.dart';

class ClearPermissionCache implements UseCase<void, String?> {
  final PermissionRepository _repo = PermissionRepository();
  @override
  Future<void> call(String? userId) => _repo.clearCache(userId: userId);
}
