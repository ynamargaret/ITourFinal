import 'package:flutter/material.dart';
import 'widgets/image_carousel.dart';

class SeeMorePage extends StatelessWidget {
  final String title;
  final String location;
  final String description;
  final List<String> inclusions;
  final String price;
  final List<String> images;
  final double? temperatureC;
  final ScrollController scrollController;

  const SeeMorePage({
    super.key,
    required this.title,
    required this.location,
    required this.description,
    required this.inclusions,
    required this.price,
    required this.images,
    required this.temperatureC,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF19183B),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 6,
                    width: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.ac_unit, color: Colors.white),
                        const SizedBox(height: 4),
                        Text(
                            temperatureC != null
                                ? "${temperatureC!.toStringAsFixed(1)}°C"
                                : "--°C",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(location,
                    style: TextStyle(
                        color: Colors.blue[100],
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(description,
                    style: const TextStyle(color: Colors.white70, height: 1.4)),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: inclusions
                      .map((inc) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(inc,
                                        style: const TextStyle(
                                            color: Colors.white70))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(price,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ImageCarousel(images: images)),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}