import '../../../core/result.dart';
import '../../../core/usecase.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class GetUser implements UseCase<Result<User>, void> {
  GetUser();

  final AuthService _repository = AuthService();

  @override
  Future<Result<User>> call(void params) async {
    var result = await _repository.user();

    return result;
  }
}
