import 'dart:async';
import 'dart:developer' as dev;

import 'package:inventory_sync_apps/core/dio_call.dart';

import '../../../core/result.dart';
import '../../../core/token.dart';
import '../../../shared/models/response.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import '../usecases/change_passsword/change_password.dart';
import '../usecases/register_with_email_password/register_with_email_password.dart';

class AuthService {
  Future<Result<AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    return dioCall<AuthResponse>(
      (dio) =>
          dio.post('/login', data: {'username': email, 'password': password}),
      parse: (data) {
        dev.log('data: $data');
        final auth = AuthResponse.fromJson(data);

        if (auth.token != null) {
          dev.log('token: ${auth.token}');
          Token.setSanctumToken(auth.token!);
        }
        return auth;
      },
    );
  }

  Future<Result<AuthResponse>> registerWithEmailPassword(RegisterParam param) {
    return dioCall<AuthResponse>(
      (dio) => dio.post(
        '/register',
        data: {
          'name': param.name,
          'email': param.email,
          'password': param.password,
        },
      ),
      parse: (data) {
        final auth = AuthResponse.fromJson(data);
        if (auth.token != null) {
          Token.setSanctumToken(auth.token!);
        }
        return auth;
      },
    );
  }

  Future<Result<AuthResponse>> loginWithGoogle({required String token}) async {
    return dioCall<AuthResponse>(
      (dio) => dio.post('/auth/login-google', data: {'token': token}),
      parse: (data) {
        final auth = AuthResponse.fromJson(data);

        if (auth.token != null) {
          Token.setSanctumToken(auth.token!);
        }
        return auth;
      },
    );
  }

  Future<Result<Response>> sendEmailChangePassword(String email) {
    return dioCall<Response>(
      (dio) =>
          dio.post('/auth/email/send/forgot-password', data: {'email': email}),
      parse: (data) => Response.fromJson(data),
    );
  }

  Future<Result<User>> user() {
    return dioCall<User>(
      (dio) => dio.get('/profile'),
      parse: (data) => User.fromJson(data['data']),
    );
  }

  Future<Result<Response>> changePassword(ChangePasswordParams param) async {
    return dioCall<Response>(
      (dio) => dio.post(
        '/auth/change-password',
        data: {
          'token': param.token,
          'password': param.password,
          'password_confirmation': param.confirmPassword,
        },
      ),
      parse: (data) => Response.fromJson(data),
    );
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Menghapus akun yang sedang login. Harus mengembalikan token sebelumnya.
  ///
  /// Returns a [Result] containing a [Response]. If the response is 204, it means
  /// the request is successful and the data is null. Otherwise, it contains the
  /// response data.
  ///
  /// Throws a [DioException] if the request fails.
  /*******  4ce67d61-21f6-4923-98eb-db420f6565e2  *******/
  Future<Result<Response>> removeAccount() {
    return dioCall<Response>(
      (dio) => dio.delete('/auth/remove-account'),
      parse: (data) {
        // kalau 204, biasanya data = null; sesuaikan modelmu
        if (data == null) return Response(message: 'Success Remove Account');
        return Response.fromJson(data);
      },
    );
  }
}
