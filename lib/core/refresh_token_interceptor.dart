import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/routes/navigation_helper.dart';
import 'package:inventory_sync_apps/core/token.dart';
import 'package:inventory_sync_apps/features/auth/presentations/blocs/auth_cubit/auth_cubit.dart';

class RefreshTokenInterceptor extends QueuedInterceptor {
  final Dio _dio;

  RefreshTokenInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Hanya handle error 401
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;

      // Cegah infinite loop jika endpoint refresh token sendiri yang return 401
      if (path.contains('/refresh-token')) {
        dev.log('Refresh token endpoint returned 401. Logging out.');
        await _performLogout();
        return handler.next(err);
      }

      dev.log('401 Unauthorized detected. Attempting to refresh token...');

      try {
        final storedToken = await Token.getSanctumToken();
        final requestTokenHeader = err.requestOptions.headers['Authorization'];
        final requestToken = requestTokenHeader is String
            ? requestTokenHeader.replaceFirst('Bearer ', '')
            : null;

        // Cek apakah token sudah berubah (sudah direfresh oleh request lain)
        if (storedToken != null &&
            requestToken != null &&
            storedToken != requestToken) {
          dev.log('Token already refreshed by another request. Retrying...');
          await _retryRequest(err.requestOptions, storedToken, handler);
          return;
        }

        if (storedToken == null) {
          await _performLogout();
          return handler.next(err);
        }

        // Buat instance Dio baru untuk refresh token agar tidak kena interceptor ini lagi
        // dan memastikan bersih.
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: baseApiUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Accept': 'application/json'},
          ),
        );

        // Pasang token lama
        refreshDio.options.headers['Authorization'] = 'Bearer $storedToken';

        // Panggil endpoint refresh token
        final response = await refreshDio.post('/refresh-token');

        if (response.statusCode == 200 && response.data['success'] == true) {
          final newToken = response.data['data']['token'];

          if (newToken != null && newToken is String) {
            dev.log('Token refreshed successfully.');
            await Token.setSanctumToken(newToken);

            // Retry request awal dengan token baru
            await _retryRequest(err.requestOptions, newToken, handler);
            return;
          }
        }
      } catch (e) {
        dev.log('Failed to refresh token: $e');
      }

      // Jika sampai sini, berarti gagal refresh atau error lain
      await _performLogout();
    }

    return handler.next(err);
  }

  /// Helper untuk retry request
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    final opts = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $newToken'},
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: requestOptions.extra,
      followRedirects: requestOptions.followRedirects,
      listFormat: requestOptions.listFormat,
      maxRedirects: requestOptions.maxRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      receiveTimeout: requestOptions.receiveTimeout,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      validateStatus: requestOptions.validateStatus,
    );

    try {
      final response = await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        cancelToken: requestOptions.cancelToken,
        options: opts,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
      );
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        return handler.next(e);
      }
      // Wrap unknown error
      return handler.next(
        DioException(requestOptions: requestOptions, error: e),
      );
    }
  }

  Future<void> _performLogout() async {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      try {
        // Panggil logout dari AuthCubit
        // Listen false agar tidak crash jika di dalam build (meski ini callback async)
        context.read<AuthCubit>().logout();
      } catch (e) {
        dev.log('Failed to logout via Cubit: $e');
        await Token.removeSanctumToken();
      }
    } else {
      await Token.removeSanctumToken();
    }
  }
}
