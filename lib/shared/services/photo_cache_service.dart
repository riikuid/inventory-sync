// lib/core/services/photo_cache_service.dart

import 'dart:developer' as dev;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PhotoCacheService {
  /// Download foto dari remote URL dan simpan ke local storage
  /// Returns: local file path jika berhasil, null jika gagal
  static Future<String?> downloadAndCache({
    required String remoteUrl,
    required String photoId,
  }) async {
    try {
      dev.log('Starting download: $remoteUrl');

      // 1. Download dari network
      final response = await http.get(Uri.parse(remoteUrl));

      if (response.statusCode != 200) {
        dev.log('Download failed with status: ${response.statusCode}');
        return null;
      }

      // 2. Dapatkan direktori untuk menyimpan foto
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photosDir = path.join(appDir.path, 'cached_photos');

      // 3. Buat folder jika belum ada
      final Directory photoFolder = Directory(photosDir);
      if (!await photoFolder.exists()) {
        await photoFolder.create(recursive: true);
      }

      // 4. Ekstrak extension dari URL (jpg, png, etc)
      String extension = path.extension(remoteUrl);
      if (extension.isEmpty || extension.length > 5) {
        // Default ke .jpg jika tidak ada extension atau extension aneh
        extension = '.jpg';
      }

      // 5. Buat nama file unik dengan photoId
      final String fileName = '${photoId}${extension}';
      final String localPath = path.join(photosDir, fileName);

      // 6. Simpan bytes ke file
      final File localFile = File(localPath);
      await localFile.writeAsBytes(response.bodyBytes);

      dev.log('Photo cached successfully at: $localPath');
      return localPath;
    } catch (e) {
      dev.log('Error downloading photo: $e');
      return null;
    }
  }

  /// Cek apakah file local masih ada di storage
  static bool isFileExists(String? localPath) {
    if (localPath == null || localPath.isEmpty) return false;
    return File(localPath).existsSync();
  }

  /// Hapus foto dari cache (opsional, untuk cleanup)
  static Future<bool> deleteCache(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      dev.log('Error deleting cache: $e');
      return false;
    }
  }

  /// Clear semua cache photos (opsional, untuk cleanup)
  static Future<void> clearAllCache() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photosDir = path.join(appDir.path, 'cached_photos');
      final Directory photoFolder = Directory(photosDir);

      if (await photoFolder.exists()) {
        await photoFolder.delete(recursive: true);
        dev.log('All photo cache cleared');
      }
    } catch (e) {
      dev.log('Error clearing cache: $e');
    }
  }
}
