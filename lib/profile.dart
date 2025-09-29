import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1A3C8C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // --- HEADER SECTION ---
                      SizedBox(
                        height: 220,
                        child: Stack(
                          children: [
                            // Background image for header
                            const Positioned.fill(
                              child: Image(
                                image: AssetImage(
                                  "assets/img/page_blur_bg.png",
                                ),
                                fit: BoxFit.cover,
                                color: Color.fromARGB(115, 0, 0, 0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Glowing Profile Picture
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent.withOpacity(
                                            0.5,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 55,
                                      backgroundImage: AssetImage(
                                        "assets/img/1.png",
                                      ),
                                    ),
                                  ),
                                  // Edit and Logout Buttons
                                  Column(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              // FIX: Removed 'const'
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.logout,
                                          size: 18,
                                        ),
                                        label: const Text("Logout"),
                                        style: _buttonStyle(),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // TODO: Implement edit profile logic
                                        },
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text("Edit"),
                                        style: _buttonStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // --- USER INFO SECTION ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "REIGN MEJIA",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.location_on, "Philippines"),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.phone, "+63 912 345 6789"),
                            const SizedBox(height: 20),
                            Text(
                              "Lover of spontaneous road trips, chasing sunsets, and finding hidden gems. Currently exploring the wonders of Southeast Asia. Next stop: Iceland!",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // --- STATS SECTION ---
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(count: "12", label: "Trips"),
                                _StatItem(count: "8", label: "Countries"),
                                _StatItem(count: "27", label: "Favorites"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // --- ACTION BUTTONS SECTION ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: ActionButton(
                        icon: Icons.help_outline,
                        text: "HELP\nABOUT THE APP",
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: ActionButton(
                        icon: Icons.nights_stay,
                        text: "SWITCH TO\nLIGHT MODE",
                        footer: Icon(
                          Icons.wb_sunny,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.arrow_back,
                        text: "RETURN TO\nHOME PAGE",
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for consistent button styling
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.9),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  // Helper for consistent info row styling
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

// --- STAT ITEM WIDGET ---
class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

// --- ACTION BUTTON WIDGET ---
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Widget? footer;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            footer ??
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
          ],
        ),
      ),
    );
  }
}
