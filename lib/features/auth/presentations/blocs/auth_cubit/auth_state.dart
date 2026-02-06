// auth_state.dart
part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

/// Loading + status message di startup (auth + sync)
final class AuthLoading extends AuthState {
  final String message;
  final double progress;
  AuthLoading(this.message, {this.progress = 0.0});
}

final class Authorized extends AuthState {
  final User user;
  final bool offline; // true = authorized tapi koneksi/sync gagal

  Authorized({required this.user, this.offline = false});
}

final class UnAuthorized extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthDatabaseCriticalError extends AuthState {
  final String message;
  AuthDatabaseCriticalError(this.message);
  @override
  List<Object?> get props => [message];
}
