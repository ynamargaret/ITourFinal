import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:country_flags/country_flags.dart';

import 'widgets/image_carousel.dart';
import 'profile.dart';
import 'trips_page.dart';
import 'destination.dart';

// ====== MAIN PAGE CONTENT ======
class HomePage extends StatefulWidget {
  final List<Destination> favorites;
  final Function(List<Destination>) onFavoritesChanged;
  
  const HomePage({
    super.key,
    required this.favorites,
    required this.onFavoritesChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _owmApiKey = 'd5c2aceb6f1347a377fbe93ecdd41971';

  String searchQuery = "";
  List<Destination> destinations = [
    Destination(
      title: "Great Wall Explorer",
      city: "Beijing",
      country: "China",
      countryCode: "CN",
      description:
          "Walk along the legendary Great Wall, a symbol of endurance and history.",
      inclusions: [
        "Flights",
        "3 nights Beijing hotel",
        "Guided Great Wall day tour",
      ],
      price: "\$1,500 per person",
      images: [
        "assets/img/great_wall1.png",
        "assets/img/great_wall2.png",
        "assets/img/great_wall3.png",
      ],
    ),
    Destination(
      title: "Machu Picchu Expedition",
      city: "Cusco",
      country: "Peru",
      countryCode: "PE",
      description:
          "Discover the mystical Incan citadel high in the Andes Mountains.",
      inclusions: [
        "Flights",
        "3 nights Cusco hotel",
        "Train + guided tour of Machu Picchu",
      ],
      price: "\$2,200 per person",
      images: [
        "assets/img/machu1.png",
        "assets/img/machu2.png",
        "assets/img/machu3.png",
      ],
    ),
    Destination(
      title: "Petra Lost City Tour",
      city: "Petra",
      country: "Jordan",
      countryCode: "JO",
      description:
          "Explore the ancient Nabatean city carved into rose-red sandstone cliffs.",
      inclusions: [
        "Flights",
        "2 nights Petra hotel",
        "Guided Petra archaeological tour",
        "Camel ride through the Siq",
      ],
      price: "\$1,700 per person",
      images: [
        "assets/img/petra1.jpg",
        "assets/img/petra2.jpg",
        "assets/img/petra3.jpg",
      ],
    ),
    Destination(
      title: "Colosseum & Ancient Rome",
      city: "Rome",
      country: "Italy",
      countryCode: "IT",
      description:
          "Step back in time to the glory of the Roman Empire and its magnificent architecture.",
      inclusions: [
        "Flights",
        "4 nights Rome hotel",
        "Colosseum & Forum guided tour",
        "Vatican City visit",
      ],
      price: "\$1,600 per person",
      images: [
        "assets/img/colosseum.jpg",
        "assets/img/colosseum2.jpg",
        "assets/img/colosseum3.jpg",
      ],
    ),
    Destination(
      title: "Chichen Itza Wonders",
      city: "Yucatan",
      country: "Mexico",
      countryCode: "MX",
      description:
          "Marvel at the ancient Mayan city and its iconic pyramid temple.",
      inclusions: [
        "Flights",
        "3 nights Cancun hotel",
        "Chichen Itza day tour",
        "Cenote swimming experience",
      ],
      price: "\$1,400 per person",
      images: [
        "assets/img/chichen1.jpg",
        "assets/img/chichen2.jpg",
        "assets/img/chichen3.jpg",
      ],
    ),
    Destination(
      title: "Christ the Redeemer & Rio Vibes",
      city: "Rio de Janeiro",
      country: "Brazil",
      countryCode: "BR",
      description:
          "Experience the vibrant culture of Rio and the iconic Christ the Redeemer statue.",
      inclusions: [
        "Flights",
        "4 nights Rio hotel",
        "Christ the Redeemer tour",
        "Copacabana beach experience",
      ],
      price: "\$1,850 per person",
      images: [
        "assets/img/christ1.jpg",
        "assets/img/christ2.jpg",
        "assets/img/christ3.jpg",
      ],
    ),
    Destination(
      title: "Taj Mahal Romance",
      city: "Agra",
      country: "India",
      countryCode: "IN",
      description:
          "Witness the eternal symbol of love, the magnificent Taj Mahal in all its glory.",
      inclusions: [
        "Flights",
        "3 nights Agra hotel",
        "Taj Mahal sunrise tour",
        "Agra Fort visit",
      ],
      price: "\$1,500 per person",
      images: [
        "assets/img/taj1.jpg",
        "assets/img/taj2.jpg",
        "assets/img/taj3.jpg",
      ],
    ),
    Destination(
      title: "Stonehenge Mysteries",
      city: "Wiltshire",
      country: "United Kingdom",
      countryCode: "GB",
      description:
          "Unravel the ancient mysteries of the prehistoric stone circle.",
      inclusions: [
        "Flights",
        "2 nights London hotel",
        "Stonehenge guided tour",
        "Bath city exploration",
      ],
      price: "\$1,300 per person",
      images: [
        "assets/img/stonehenge1.jpg",
        "assets/img/stonehenge2.jpg",
        "assets/img/stonehenge3.jpg",
      ],
    ),
    Destination(
      title: "Northern Lights Hunt",
      city: "Reykjavik",
      country: "Iceland",
      countryCode: "IS",
      description:
          "Chase the magical aurora borealis across Iceland's stunning landscapes.",
      inclusions: [
        "Flights",
        "3 nights Reykjavik hotel",
        "Northern Lights tour",
        "Blue Lagoon experience",
      ],
      price: "\$2,100 per person",
      images: [
        "assets/img/northern1.jpg",
        "assets/img/northern2.jpg",
        "assets/img/northern3.jpg",
      ],
    ),
    Destination(
      title: "Pyramids of Giza Discovery",
      city: "Cairo",
      country: "Egypt",
      countryCode: "EG",
      description:
          "Stand in awe before the last remaining wonder of the ancient world.",
      inclusions: [
        "Flights",
        "3 nights Cairo hotel",
        "Pyramids & Sphinx tour",
        "Nile River cruise",
      ],
      price: "\$1,750 per person",
      images: [
        "assets/img/pyramids1.jpg",
        "assets/img/pyramids2.jpg",
        "assets/img/pyramids3.jpg",
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _syncFavorites();
    _fetchAllWeathers();
  }

  void _syncFavorites() {
    // Sync destination favorite states with the shared favorites list
    for (var destination in destinations) {
      destination.isFavorite = widget.favorites.any((fav) => fav.title == destination.title);
    }
  }

  void _toggleFavorite(Destination d) {
    setState(() {
      d.isFavorite = !d.isFavorite;
    });
    
    // Update the shared favorites list
    List<Destination> updatedFavorites = destinations.where((dest) => dest.isFavorite).toList();
    widget.onFavoritesChanged(updatedFavorites);
  }

  Future<void> _openBookingForm(String destinationName) async {
    final proceed = await _showBookingConfirmationDialog();
    if (!proceed) return;
    
    // Navigate to TripsPage with pre-filled destination
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripsPage(prefilledDestination: destinationName),
      ),
    );
  }

  Future<bool> _showBookingConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF23224B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Start Booking Session',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to start a new booking? You have 10 minutes to complete your booking or it will expire.',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA1C2BD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Proceed', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _fetchAllWeathers() async {
    for (var d in destinations) {
      final weather = await _fetchWeather(d.city);
      setState(() {
        d.temperatureC = weather['temp'];
        d.weatherMain = weather['main'];
      });
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  Future<Map<String, dynamic>> _fetchWeather(String city) async {
    try {
      final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'q': city,
        'units': 'metric',
        'appid': _owmApiKey,
      });

      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        return {
          'temp': (json['main']['temp'] as num).toDouble(),
          'main': json['weather'][0]['main'],
        };
      }
      return {'temp': null, 'main': null};
    } catch (_) {
      return {'temp': null, 'main': null};
    }
  }

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

  // ====== CARD BUILDER ======
  Widget _buildDestinationCard(Destination d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF19183B),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Weather
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Icon(
                        _getWeatherIcon(d.weatherMain),
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d.temperatureC != null
                            ? "${d.temperatureC!.toStringAsFixed(1)}°C"
                            : "--°C",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // City + Country flag
              Row(
                children: [
                  CountryFlag.fromCountryCode(
                    d.countryCode,
                    height: 18,
                    width: 25,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${d.city}, ${d.country}",
                    style: GoogleFonts.poppins(
                      color: Colors.blue[100],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                d.description,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: d.inclusions
                    .map(
                      (inc) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "• $inc",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),
              Text(
                d.price,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ImageCarousel(images: d.images),
              ),

              const SizedBox(height: 14),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: IconButton(
                      icon: Icon(
                        d.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => _toggleFavorite(d),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _openBookingForm(d.title),
                        child: Text(
                          "Book Now",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Destination> get _filteredDestinations {
    if (searchQuery.isEmpty) return destinations;
    return destinations
        .where(
          (d) =>
              d.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              d.city.toLowerCase().contains(searchQuery.toLowerCase()) ||
              d.country.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome Reign!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage("assets/img/1.png"),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 20),
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: GoogleFonts.poppins(),
                onChanged: (val) {
                  setState(() => searchQuery = val);
                },
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  hintStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Destinations',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._filteredDestinations.map(_buildDestinationCard),
          ],
        ),
      ),
    );
  }
}
