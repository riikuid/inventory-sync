import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/constant.dart';

import '../../services/photo_cache_service.dart';

// Public state class untuk bisa diakses dari luar
class OfflineSmartImageState extends State<OfflineSmartImage> {
  String? _cachedLocalPath;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _cachedLocalPath = widget.localPath;

    if (_shouldDownload()) {
      _downloadAndCache();
    }
  }

  @override
  void didUpdateWidget(OfflineSmartImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.localPath != oldWidget.localPath) {
      setState(() {
        _cachedLocalPath = widget.localPath;
      });
    }

    if (_shouldDownload() && !_isDownloading) {
      _downloadAndCache();
    }
  }

  bool _shouldDownload() {
    if (widget.photoId == null || widget.remoteUrl == null) return false;
    if (_isDownloading) return false;

    if (_cachedLocalPath == null || _cachedLocalPath!.isEmpty) return true;

    return !PhotoCacheService.isFileExists(_cachedLocalPath);
  }

  Future<void> _downloadAndCache() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final String fullUrl = widget.remoteUrl!.startsWith('http')
          ? widget.remoteUrl!
          : '$baseUrl/${widget.remoteUrl}';

      dev.log('Auto-downloading image: $fullUrl');

      final localPath = await PhotoCacheService.downloadAndCache(
        remoteUrl: fullUrl,
        photoId: widget.photoId!,
      );

      if (localPath != null && mounted) {
        setState(() {
          _cachedLocalPath = localPath;
          _isDownloading = false;
        });

        widget.onCacheComplete?.call(widget.photoId!, localPath);

        dev.log('Image cached successfully: $localPath');
      } else {
        setState(() {
          _isDownloading = false;
        });
      }
    } catch (e) {
      dev.log('Error in auto-download: $e');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  // Public helper methods
  String? getCurrentImagePath() {
    if (_cachedLocalPath != null &&
        _cachedLocalPath!.isNotEmpty &&
        PhotoCacheService.isFileExists(_cachedLocalPath)) {
      return _cachedLocalPath;
    }

    if (widget.remoteUrl != null && widget.remoteUrl!.isNotEmpty) {
      return widget.remoteUrl!.startsWith('http')
          ? widget.remoteUrl!
          : '$baseUrl/${widget.remoteUrl}';
    }

    return null;
  }

  bool isCurrentImageLocal() {
    return _cachedLocalPath != null &&
        _cachedLocalPath!.isNotEmpty &&
        PhotoCacheService.isFileExists(_cachedLocalPath);
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContent = _buildImageContent(context);

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        child: imageContent,
      );
    }
    return imageContent;
  }

  Widget _buildImageContent(BuildContext context) {
    if (_cachedLocalPath != null && _cachedLocalPath!.isNotEmpty) {
      final file = File(_cachedLocalPath!);
      if (file.existsSync()) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Image.file(
            file,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            errorBuilder: (context, error, stackTrace) {
              dev.log('Error loading local file, fallback to remote');
              return _buildRemoteImage(context);
            },
          ),
        );
      }
    }

    return _buildRemoteImage(context);
  }

  Widget _buildRemoteImage(BuildContext context) {
    if (widget.remoteUrl != null && widget.remoteUrl!.isNotEmpty) {
      String imageUrl = widget.remoteUrl!.startsWith('http')
          ? widget.remoteUrl!
          : '$baseUrl/${widget.remoteUrl}';

      return GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorPlaceholder();
              },
            ),
            if (_isDownloading)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Caching...',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
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

class OfflineSmartImage extends StatefulWidget {
  final String? photoId;
  final String? localPath;
  final String? remoteUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Function(String photoId, String localPath)? onCacheComplete;
  final VoidCallback? onTap;

  const OfflineSmartImage({
    super.key,
    this.photoId,
    this.localPath,
    this.remoteUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.onCacheComplete,
    this.onTap,
  });

  @override
  OfflineSmartImageState createState() => OfflineSmartImageState();
}
