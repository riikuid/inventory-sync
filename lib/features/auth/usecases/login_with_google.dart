import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/result.dart';
import '../../../core/usecase.dart';
import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<Result<AuthResponse>, void> {
  LoginWithGoogle();

  final AuthService _repository = AuthService();

  @override
  Future<Result<AuthResponse>> call(void params) async {
    final List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);

    GoogleSignInAuthentication? googleSignInAuthentication;

    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      googleSignInAuthentication = await googleSignInAccount?.authentication;
    } catch (error) {
      return Result.failed(error.toString());
    }

    String token = googleSignInAuthentication?.accessToken ?? '';

    var result = await _repository.loginWithGoogle(token: token);

    return result;
  }
}
