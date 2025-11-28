// lib/features/sync/data/sync_api.dart
import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/dio_call.dart';
import 'package:inventory_sync_apps/core/dio.dart'; // DioClient
import 'package:inventory_sync_apps/core/result.dart';

class SyncApi {
  Future<Result<Map<String, dynamic>>> pull({String? sinceIso}) async {
    return dioCall<Map<String, dynamic>>(
      (dio) => dio.get(
        '/sync/pull',
        queryParameters: sinceIso != null ? {'since': sinceIso} : null,
      ),
      parse: (data) => data as Map<String, dynamic>,
    );
  }

  Future<Result<Map<String, dynamic>>> push(
    Map<String, dynamic> payload,
  ) async {
    return dioCall<Map<String, dynamic>>(
      (dio) => dio.post('/sync/push', data: payload),
      parse: (data) => data as Map<String, dynamic>,
    );
  }
}
