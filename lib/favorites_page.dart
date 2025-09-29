import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_flags/country_flags.dart';

import 'destination.dart';
import 'widgets/image_carousel.dart';

// Convert to a StatefulWidget to manage the selected item's state
class FavoritesPage extends StatefulWidget {
  final List<Destination> favorites;
  final Function(Destination) onFavoriteRemoved;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.onFavoriteRemoved,
  });

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // This will hold the destination the user taps on to see details
  Destination? _selectedFavorite;

  // Helper function to get the correct weather icon
  IconData _getWeatherIcon(String? main) {
    switch (main) {
      case "Clear":
        return Icons.wb_sunny;
      case "Clouds":
        return Icons.cloud;
      case "Rain":
        return Icons.beach_access;
      case "Snow":
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19183B),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF19183B),
        elevation: 0,
        title: Text(
          // Show different titles based on the view
          _selectedFavorite == null ? 'Favorites' : 'Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Conditionally show either the list or the detailed view
      body: _selectedFavorite == null
          ? _buildFavoritesList()
          : _buildDetailedCard(_selectedFavorite!),
    );
  }

  // --- WIDGET FOR THE INITIAL LIST OF FAVORITES ---
  Widget _buildFavoritesList() {
    if (widget.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No favorites yet',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the heart icon to add destinations to your favorites',
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.favorites.length,
      itemBuilder: (context, index) {
        final d = widget.favorites[index];
        return _buildSimpleFavoriteCard(d);
      },
    );
  }

  // --- WIDGET FOR A SINGLE ITEM IN THE SIMPLE LIST ---
  Widget _buildSimpleFavoriteCard(Destination d) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFavorite = d; // Set the selected favorite to show details
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                d.images.first,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${d.city}, ${d.country}',
                    style: GoogleFonts.poppins(
                      color: Colors.blue[200],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              tooltip: "Remove from Favorites",
              onPressed: () => widget.onFavoriteRemoved(d),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET FOR THE DETAILED GLOWING CARD VIEW ---
  Widget _buildDetailedCard(Destination d) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF19183B),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Weather
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        d.title.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Icon(
                          _getWeatherIcon(d.weatherMain),
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          d.temperatureC != null
                              ? "${d.temperatureC!.toStringAsFixed(1)}°C"
                              : "--°C",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // City + Country flag
                Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      d.countryCode,
                      height: 22,
                      width: 30,
                      borderRadius: 4,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${d.city}, ${d.country}",
                      style: GoogleFonts.poppins(
                        color: Colors.blue[100],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  d.description,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Inclusions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: d.inclusions
                      .map(
                        (inc) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "• $inc",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  d.price,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ImageCarousel(images: d.images),
                ),
                const SizedBox(height: 14),
                // Back Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: "Back to Favorites List",
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _selectedFavorite =
                                null; // Clear selection to go back
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
