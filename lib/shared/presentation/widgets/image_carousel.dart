import 'package:flutter/material.dart';

import '../../../core/db/model/photo_row.dart';
import '../../../core/styles/color_scheme.dart';
import 'offline_smart_image.dart';

class ImageCarousel extends StatefulWidget {
  // Terima List<VariantPhotoRow> bukan List<String>
  final List<PhotoRow> photos;

  const ImageCarousel({super.key, required this.photos});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    // 1. Placeholder jika tidak ada foto
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
          // A. GAMBAR (PageView)
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

                // === PENERAPAN OfflineSmartImage ===
                return Container(
                  color: Colors.grey.shade100,
                  child: OfflineSmartImage(
                    localPath: photo.localPath,
                    remoteUrl: photo.remoteUrl,
                    fit: BoxFit.cover,
                    // Tambahkan error builder jika widget Anda mendukungnya
                  ),
                );
              },
            ),
          ),

          // Jika gambar > 1, tampilkan navigasi
          if (widget.photos.length > 1) ...[
            // B. TOMBOL KIRI
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

            // C. TOMBOL KANAN
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

            // D. DOT INDICATOR
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
                          : Colors.white.withOpacity(
                              0.8,
                            ), // Sedikit lebih solid agar terlihat di atas gambar
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
