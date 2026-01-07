import 'dart:developer' as dev;

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
              dev.log(imageUrls.first, name: 'isLocal: $isLocal');
              return PhotoViewGalleryPageOptions(
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 32,
                    ),
                  );
                },
                imageProvider: isLocal
                    ? AssetImage(imageUrls[index])
                    : NetworkImage(
                        imageUrls[index],
                      ), // AssetImage/Image.network
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              );
            },
            loadingBuilder: (context, event) =>
                const Center(child: CircularProgressIndicator()),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
