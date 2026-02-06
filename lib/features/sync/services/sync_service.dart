// lib/features/sync/data/sync_api.dart
import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/dio_call.dart';
import 'package:inventory_sync_apps/core/result.dart';

import '../data/models/photo_upload_response.dart';

class SyncService {
  Future<Result<Map<String, dynamic>>> pull({String? sinceIso}) async {
    return dioCall<Map<String, dynamic>>(
      (dio) => dio.get(
        '/sync/pull',
        queryParameters: sinceIso != null ? {'since': sinceIso} : null,
        options: Options(extra: {'silent': true}),
      ),

      parse: (data) => data as Map<String, dynamic>,
      isSilent: true,
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

  Future<Result<UploadPhotoResponse>> uploadPhoto({
    required String id,
    required String type, // 'variant' atau 'component'
    required String filePath,
  }) async {
    return dioCall<UploadPhotoResponse>(
      (dio) async {
        final formData = FormData.fromMap({
          'id': id,
          'type': type,
          'file': await MultipartFile.fromFile(filePath),
        });

        return dio.post('/photos/upload', data: formData);
      },
      parse: (data) =>
          UploadPhotoResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}
