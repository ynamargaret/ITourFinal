// widgets/image_carousel.dart
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1.0 so neighboring images are visible
    _pageController = PageController(viewportFraction: 0.78, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper to safely render asset images with fallback
  Widget _buildImage(String assetPath) {
    String primary = assetPath;
    String alt;
    if (primary.endsWith('.png')) {
      alt = primary.replaceAll('.png', '.jpg');
    } else if (primary.endsWith('.jpg')) {
      alt = primary.replaceAll('.jpg', '.png');
    } else {
      // If no extension provided, try png first then jpg
      primary = '$assetPath.png';
      alt = '$assetPath.jpg';
    }

    return Image.asset(
      primary,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Try alternate extension
        return Image.asset(
          alt,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // If asset not found, show a neutral placeholder
            return Container(
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 48, color: Colors.black38),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text('No images', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              // Using AnimatedBuilder to compute scale/opacity relative to page position
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = 0;
                  try {
                    page = _pageController.hasClients ? (_pageController.page ?? _pageController.initialPage.toDouble()) : _pageController.initialPage.toDouble();
                  } catch (_) {
                    page = _pageController.initialPage.toDouble();
                  }
                  double distance = (page - index).abs();
                  // closer to 0 -> scale ~1.0 ; further -> smaller
                  double scale = (1 - (distance * 0.15)).clamp(0.85, 1.0);
                  double opacity = (1 - (distance * 0.5)).clamp(0.4, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: _buildImage(images[index]),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == i ? 12 : 8,
              height: _currentIndex == i ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentIndex == i ? Colors.white : Colors.white54,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
