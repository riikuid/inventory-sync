part of 'change_password.dart';

class ChangePasswordParams {
  final String token;
  final String password, confirmPassword;

  ChangePasswordParams(
      {required this.token,
      required this.password,
      required this.confirmPassword});
}
