import '../../../core/result.dart';
import '../../../core/usecase.dart';
import '../../../shared/models/response.dart';
import '../repositories/auth_repository.dart';

class SendEmailChangePassword implements UseCase<Result<Response>, String> {
  SendEmailChangePassword();

  final AuthService _repository = AuthService();

  @override
  Future<Result<Response>> call(String params) async {
    var result = await _repository.sendEmailChangePassword(params);

    return result;
  }
}
