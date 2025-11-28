import 'dart:async';
import 'package:dio/dio.dart';

import 'package:inventory_sync_apps/core/constant.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'token.dart';

class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  Dio? _dio;
  // String? _cachedUserAgent;
  final _talker = Talker();

  Future<Dio> get instance async {
    if (_dio != null) return _dio!;

    final options = BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        // 'User-Agent': _cachedUserAgent,
        'Accept': 'application/json',
      },
    );

    final dio = Dio(options);

    // Logging interceptor pakai Talker
    dio.interceptors.add(
      TalkerDioLogger(
        talker: _talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: true,
          printErrorData: true,
        ),
      ),
    );

    // Authorization otomatis
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
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

    _dio = dio;
    return _dio!;
  }
}
