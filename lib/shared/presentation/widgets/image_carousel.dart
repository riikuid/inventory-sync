import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/db/model/photo_row.dart';
import '../../../core/styles/color_scheme.dart';
import '../../../core/utils/photo_gallery_viewer.dart';
import '../../../features/inventory/data/inventory_repository.dart';
import 'offline_smart_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<PhotoRow> photos;

  const ImageCarousel({super.key, required this.photos});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Store GlobalKeys for each OfflineSmartImage to access their state
  final Map<int, GlobalKey<OfflineSmartImageState>> _imageKeys = {};

  @override
  void initState() {
    super.initState();
    // Create keys for all images
    for (int i = 0; i < widget.photos.length; i++) {
      _imageKeys[i] = GlobalKey<OfflineSmartImageState>();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Callback untuk update DB setelah download selesai
  void _onPhotoDownloaded(String photoId, String localPath) {
    try {
      final repo = context.read<InventoryRepository>();
      repo.updatePhotoLocalPath(photoId: photoId, localPath: localPath);
    } catch (e) {
      debugPrint('Error updating photo local path: $e');
    }
  }

  // Handler untuk membuka gallery dengan semua foto
  void _openPhotoGallery(int initialIndex) {
    // Kumpulkan semua image paths dan status local/remote
    final List<String> imagePaths = [];
    bool hasAnyLocal = false;

    for (int i = 0; i < widget.photos.length; i++) {
      final imageKey = _imageKeys[i];
      final imageState = imageKey?.currentState;

      if (imageState != null) {
        final path = imageState.getCurrentImagePath();
        if (path != null) {
          imagePaths.add(path);
          if (imageState.isCurrentImageLocal()) {
            hasAnyLocal = true;
          }
        }
      } else {
        // Fallback jika state belum ready
        final photo = widget.photos[i];
        if (photo.localPath != null && photo.localPath!.isNotEmpty) {
          imagePaths.add(photo.localPath!);
          hasAnyLocal = true;
        } else if (photo.remoteUrl != null && photo.remoteUrl!.isNotEmpty) {
          imagePaths.add(photo.remoteUrl!);
        }
      }
    }

    if (imagePaths.isEmpty) return;

    // Buka gallery
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoGalleryViewer(
          imageUrls: imagePaths,
          isLocal: hasAnyLocal, // True jika ada foto local
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder jika tidak ada foto
    if (widget.photos.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 40,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // GAMBAR (PageView)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.photos.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final photo = widget.photos[index];

                return Container(
                  color: Colors.grey.shade100,
                  child: OfflineSmartImage(
                    key: _imageKeys[index], // Set key untuk akses state
                    photoId: photo.id,
                    localPath: photo.localPath,
                    remoteUrl: photo.remoteUrl,
                    fit: BoxFit.cover,
                    onCacheComplete: _onPhotoDownloaded,
                    onTap: () => _openPhotoGallery(
                      index,
                    ), // Pass index untuk initial page
                  ),
                );
              },
            ),
          ),

          // Navigasi jika gambar > 1
          if (widget.photos.length > 1) ...[
            // TOMBOL KIRI
            if (_currentIndex > 0)
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildNavButton(
                    icon: Icons.chevron_left,
                    onTap: _prevPage,
                  ),
                ),
              ),

            // TOMBOL KANAN
            if (_currentIndex < widget.photos.length - 1)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildNavButton(
                    icon: Icons.chevron_right,
                    onTap: _nextPage,
                  ),
                ),
              ),

            // DOT INDICATOR
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photos.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 8,
                    width: _currentIndex == index ? 20 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
