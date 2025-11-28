import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../models/auth_response.dart';
import '../../repositories/auth_repository.dart';

part 'register_params.dart';

class RegisterWithEmailPassword
    implements UseCase<Result<AuthResponse>, RegisterParam> {
  RegisterWithEmailPassword();

  final AuthRepository _repository = AuthRepository();

  @override
  Future<Result<AuthResponse>> call(RegisterParam params) async {
    var result = await _repository.registerWithEmailPassword(params);

    return result;
  }
}
