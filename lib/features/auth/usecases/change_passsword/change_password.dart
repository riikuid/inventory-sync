import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../../shared/models/response.dart';
import '../../repositories/auth_repository.dart';

part 'change_password_params.dart';

class ChangePassword
    implements UseCase<Result<Response>, ChangePasswordParams> {
  ChangePassword();

  final AuthService _repository = AuthService();

  @override
  Future<Result<Response>> call(ChangePasswordParams params) async {
    var result = await _repository.changePassword(params);

    return result;
  }
}
