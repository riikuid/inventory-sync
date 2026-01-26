import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../models/auth_response.dart';
import '../../repositories/auth_repository.dart';

part 'login_with_email_password_params.dart';

class LoginWithEmailPassword
    implements UseCase<Result<AuthResponse>, LoginWithEmailPasswordParams> {
  LoginWithEmailPassword();

  final AuthService _repository = AuthService();

  @override
  Future<Result<AuthResponse>> call(LoginWithEmailPasswordParams params) async {
    var result = await _repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );

    return result;
  }
}
