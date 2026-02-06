import '../../../core/result.dart';
import '../../../core/usecase.dart';
import '../../../shared/models/response.dart';
import '../repositories/auth_repository.dart';

class RemoveAccount implements UseCase<Result<Response>, void> {
  RemoveAccount();

  final AuthService _repository = AuthService();

  @override
  Future<Result<Response>> call(void params) async {
    var result = await _repository.removeAccount();

    return result;
  }
}
