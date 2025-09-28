import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'trips_page.dart';
import 'about_us.dart';
import 'destination.dart';

// This StatefulWidget is the root of our main UI. It manages the bottom
// navigation bar and, most importantly, holds the shared state for favorites.
class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;
  // This list acts as the central "source of truth" for the user's favorite destinations.
  // By holding the state here, we can ensure all child pages are in sync.
  List<Destination> _favorites = [];

  // This function is passed down to the HomePage. When a user favorites an item,
  // HomePage calls this function to update the state in this parent widget.
  void _updateFavorites(List<Destination> favorites) {
    setState(() {
      _favorites = favorites;
    });
  }

  // This function is passed down to the FavoritesPage. When a user unfavorites
  // an item there, it calls this function to update the central list.
  void _removeFavorite(Destination destination) {
    setState(() {
      destination.isFavorite = false;
      _favorites.removeWhere((d) => d.title == destination.title);
    });
  }

  // A getter that builds our list of pages. Notice how the '_favorites' list
  // and the state management functions are passed into the relevant pages.
  List<Widget> get _pages => [
        HomePage(favorites: _favorites, onFavoritesChanged: _updateFavorites),
        FavoritesPage(favorites: _favorites, onFavoriteRemoved: _removeFavorite),
        const TripsPage(),
        const AboutUsPage(),
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
              offset: const Offset(0, -3),
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