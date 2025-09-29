import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'trips_page.dart';
import 'about_us.dart';
import 'destination.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;
  List<Destination> _favorites = [];

  void _updateFavorites(List<Destination> favorites) {
    setState(() {
      _favorites = favorites;
    });
  }

  // --- NEW FUNCTION ---
  // This function will be called from the FavoritesPage to remove an item.
  void _removeFavorite(Destination destination) {
    setState(() {
      // Remove the destination from the list.
      // We also update its 'isFavorite' status for consistency.
      destination.isFavorite = false;
      _favorites.removeWhere((d) => d.title == destination.title);
    });
  }

  // --- MODIFIED _pages GETTER ---
  List<Widget> get _pages => [
    HomePage(favorites: _favorites, onFavoritesChanged: _updateFavorites),

    FavoritesPage(favorites: _favorites, onFavoriteRemoved: _removeFavorite),
    TripsPage(),
    AboutUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19183B),
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.favorite, "Favorites", 1),
                _buildNavItem(Icons.event_available, "Bookings", 2),
                _buildNavItem(Icons.info, "About Us", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _index == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _index = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.blue.shade900 : Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
