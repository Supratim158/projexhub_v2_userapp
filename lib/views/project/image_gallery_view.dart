import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageGalleryView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageGalleryView({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageGalleryView> createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "${_currentIndex + 1} / ${widget.images.length}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return InteractiveViewer(
              panEnabled: true, // Set it to false
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 1.0,
              maxScale: 4.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.images[index]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
