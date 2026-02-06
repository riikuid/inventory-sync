import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGalleryViewer extends StatelessWidget {
  final List<String> imageUrls;
  final bool isLocal;
  final int initialIndex;

  const PhotoGalleryViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.isLocal = false,
  });

  @override
  /// Builds a [Scaffold] with a [PhotoViewGallery] inside.
  /// The [PhotoViewGallery] displays the images at [imageUrls].
  /// The [isLocal] parameter determines whether the images are loaded from
  /// the network or from local assets.
  /// The [initialIndex] parameter determines which image to display first.
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            pageController: pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (context, index) {
              dev.log(
                'Loading image: ${imageUrls[index]}',
                name: 'PhotoGallery - isLocal: $isLocal',
              );

              return PhotoViewGalleryPageOptions(
                errorBuilder: (context, error, stackTrace) {
                  dev.log(
                    'Error loading image: $error',
                    name: 'PhotoGallery Error',
                  );
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gagal memuat gambar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
                // FIX: Gunakan FileImage untuk local files, bukan AssetImage
                imageProvider: isLocal
                    ? FileImage(File(imageUrls[index])) as ImageProvider
                    : NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              );
            },
            loadingBuilder: (context, event) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: event == null
                        ? null
                        : event.cumulativeBytesLoaded /
                              (event.expectedTotalBytes ?? 1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat gambar...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Page indicator (jika lebih dari 1 foto)
          if (imageUrls.length > 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      int currentPage = initialIndex;
                      if (pageController.hasClients &&
                          pageController.page != null) {
                        currentPage = pageController.page!.round();
                      }
                      return Text(
                        '${currentPage + 1} / ${imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
