import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/utils/photo_gallery_viewer.dart';

class OfflineSmartImage extends StatelessWidget {
  final String? localPath;
  final String? remoteUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double? borderRadius;

  const OfflineSmartImage({
    super.key,
    this.localPath,
    this.remoteUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageContent = _buildImageContent(context);
    dev.log(
      'DEBUG WIDGET: Building Image. Local: $localPath, Remote: $remoteUrl',
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: imageContent,
      );
    }
    return imageContent;
  }

  Widget _buildImageContent(BuildContext context) {
    // 1. Prioritas Utama: File Lokal
    if (localPath != null && localPath!.isNotEmpty) {
      final file = File(localPath!);
      // Cek sinkronus apakah file ada (untuk UX instan).
      // Jika file path ada di DB tapi file fisik terhapus, kita fallback ke network.
      if (file.existsSync()) {
        dev.log('INI FILE PATH: ${file.path}');
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhotoGalleryViewer(imageUrls: [file.path], isLocal: true),
              ),
            );
          },

          child: Image.file(
            file,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              // Jika file corrupt/gagal load, coba remote
              return _buildRemoteImage(context);
            },
          ),
        );
      }
    }

    // 2. Fallback: Remote URL
    return _buildRemoteImage(context);
  }

  Widget _buildRemoteImage(BuildContext context) {
    if (remoteUrl != null && remoteUrl!.isNotEmpty) {
      String imageUrl = '$baseUrl/$remoteUrl';
      return GestureDetector(
        onTap: () {
          dev.log('INI REMOTE URL: $imageUrl');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PhotoGalleryViewer(imageUrls: [imageUrl], isLocal: false),
            ),
          );
        },
        child: Image.network(
          imageUrl,
          fit: fit,
          width: width,
          height: height,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        ),
      );
    }

    // 3. Jika Local & Remote Null/Gagal
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey.shade400,
          size: 24,
        ),
      ),
    );
  }
}
