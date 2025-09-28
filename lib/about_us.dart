import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/page_blur_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/img/itour_logo.png"),
              ),
              const SizedBox(height: 20),
              const Text(
                "ITOUR",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "🇵🇭 Philippines",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                "facebook: itourARQ.com",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                    child: _TeamCard(
                      name: "Allysa",
                      username: "chae-oop",
                      image: "assets/img/profile_allysa.png",
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: _TeamCard(
                      name: "Reign",
                      username: "reinmiela",
                      image: "assets/img/profile_reign.png",
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: _TeamCard(
                      name: "Allyna",
                      username: "ynamargaret",
                      image: "assets/img/profile_allyna.png",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "Developed @2025",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String name;
  final String username;
  final String image;

  const _TeamCard({
    required this.name,
    required this.username,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: AssetImage(image)),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            username,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}