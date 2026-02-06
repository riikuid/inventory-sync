import 'dart:async';
import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:inventory_sync_apps/core/constant.dart';
import 'token.dart';
import 'refresh_token_interceptor.dart';
import 'config.dart'; // Pastikan Config diimport

class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  Dio? _dio;
  final _talker = Talker();

  Talker get talker => _talker;

  Future<Dio> get instance async {
    if (_dio != null) return _dio!;

    final options = BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    );

    final dio = Dio(options);

    // 1. Cek Global Config (Production = Off)
    final bool isGlobalLoggingEnabled = !Config.isProduction();

    if (isGlobalLoggingEnabled) {
      // 2. Gunakan Custom Logger (SilentTalkerDioLogger) menggantikan TalkerDioLogger biasa
      dio.interceptors.add(
        SilentTalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestData: true,
            printResponseData: true,
            printErrorData: true,
          ),
        ),
      );
    }

    // Authorization
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // CHECK: Jika header Authorization sudah ada (misal dari Service tertentu),
          // jangan ditimpa dengan token default (Sanctum).
          if (options.headers.containsKey('Authorization')) {
            handler.next(options);
            return;
          }

          final token = await Token.getSanctumToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          handler.next(options);
        },
      ),
    );

    // Refresh Token Interceptor
    dio.interceptors.add(RefreshTokenInterceptor(dio));

    _dio = dio;
    return _dio!;
  }
}

/// --- CUSTOM LOGGER CLASS ---
/// Class ini berfungsi untuk mengecek apakah request memiliki flag 'silent'.
/// Jika ya, log tidak akan dicetak.
class SilentTalkerDioLogger extends TalkerDioLogger {
  SilentTalkerDioLogger({super.talker, super.settings});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['silent'] == true) {
      handler.next(options);
      return;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['silent'] == true) {
      handler.next(response);
      return;
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra['silent'] == true) {
      handler.next(err);
      return;
    }
    super.onError(err, handler);
  }
}
