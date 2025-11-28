part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class Authorized extends AuthState {
  final User user;
  Authorized({required this.user});
}

final class UnAuthorized extends AuthState {}

final class AuthError extends AuthState {}
