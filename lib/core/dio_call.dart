// safe_call.dart
import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/dio.dart';
import 'package:inventory_sync_apps/core/result.dart';

import 'config.dart';
import 'constant.dart';
import 'response_code.dart';

typedef Parser<T> = T Function(dynamic data);

/// Helper universal untuk memanggil endpoint dan memetakan ke Result<T>.
Future<Result<T>> dioCall<T>(
  Future<Response<dynamic>> Function(Dio dio) request, {
  required Parser<T> parse,
  String Function(dynamic data)? serverMessageExtractor,
}) async {
  try {
    final dio = await DioClient().instance;
    final res = await request(
      dio,
    ); // 2xx -> tidak throw (default Dio melempar utk !2xx)
    final data = res.data;
    return Result.success(parse(data), statusCode: res.statusCode);
  } on DioException catch (e) {
    // Klasifikasi error
    final type = e.type;
    final resp = e.response;
    final code = resp?.statusCode;

    // 1) Timeout / jaringan
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return Result.failed(timeoutMessage, statusCode: code);
    }
    if (type == DioExceptionType.unknown) {
      return Result.failed(noConnectionMessage, statusCode: code);
    }

    // 2) Error dengan response (non-2xx)
    final body = resp?.data;
    final serverMsg = () {
      if (serverMessageExtractor != null) return serverMessageExtractor(body);
      if (body is Map && body['message'] is String) {
        return body['message'] as String;
      }
      return resp?.statusMessage;
    }();

    // Kamu bisa tambahkan mapping khusus per status code di sini
    if (code == ResponseCode.unAuthorized) {
      // contoh: trigger logout di bloc luar (jangan langsung di helper)
      // cukup pulangkan pesan konsisten
    }

    final msg =
        serverMsg ??
        (Config.isProduction() ? errorMessage : (e.message ?? 'HTTP Error'));
    return Result.failed(msg, statusCode: code);
  } catch (e) {
    // 3) Unknown non-Dio error
    final msg = Config.isProduction() ? errorMessage : e.toString();
    return Result.failed(msg);
  }
}
