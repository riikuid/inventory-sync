import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/dio.dart'; // Pastikan import ini benar arahnya ke DioClient
import 'package:inventory_sync_apps/core/result.dart';

import 'config.dart';
import 'constant.dart';
import 'response_code.dart';

typedef Parser<T> = T Function(dynamic data);

/// Helper universal untuk memanggil endpoint dan memetakan ke Result<T>.
///
/// [isSilent] -> Jika true, error parsing/logic internal tidak akan dikirim ke Logger.
/// (Catatan: Untuk mematikan Log HTTP Request/Response, gunakan Options(extra: {'silent': true}) di dalam [request])
Future<Result<T>> dioCall<T>(
  Future<Response<dynamic>> Function(Dio dio) request, {
  required Parser<T> parse,
  String Function(dynamic data)? serverMessageExtractor,
  bool isSilent = false, // <--- PERUBAHAN 1: Parameter baru
}) async {
  try {
    final dio = await DioClient().instance;
    final res = await request(dio);

    final data = res.data;
    return Result.success(parse(data), statusCode: res.statusCode);
  } on DioException catch (e) {
    // --- Error HTTP (Dio) ---
    // Error ini biasanya sudah dicatat oleh Interceptor di DioClient,
    // jadi kita tidak perlu log manual di sini supaya tidak duplikat.

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
      // DEBUG: Expose actual error for debugging
      final debugMsg = e.error?.toString() ?? e.message ?? 'Unknown Error';
      return Result.failed(
        '$noConnectionMessage\nDebug: $debugMsg',
        statusCode: code,
      );
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

    if (code == ResponseCode.unAuthorized) {
      // Handle logout logic if needed
    }

    final msg =
        serverMsg ??
        (Config.isProduction() ? errorMessage : (e.message ?? 'HTTP Error'));
    return Result.failed(msg, statusCode: code);
  } catch (e, stackTrace) {
    // <--- PERUBAHAN 2: Tangkap stackTrace
    // --- Error Non-HTTP (Parsing / Logic) ---
    // Contoh: Field JSON berubah, tipe data salah, atau logic error di fungsi parse()

    // PERUBAHAN 3: Log error misterius ini ke Talker agar mudah didebug
    if (!isSilent && !Config.isProduction()) {
      DioClient().talker.error(
        'Error in dioCall (Parsing/Logic)',
        e,
        stackTrace,
      );
    }

    final msg = Config.isProduction() ? errorMessage : e.toString();
    return Result.failed(msg);
  }
}
