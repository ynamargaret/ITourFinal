import 'package:flutter/material.dart';
// import home page
import 'main_tabs.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.indigo.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Overlay image with opacity
          Opacity(
            opacity: 0.65, // Adjust for desired effect
            child: Image.asset(
              "assets/img/login_bg.png", // Use your overlay image path
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Main content (make scrollable and safe)
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // Fill screen height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  children: [
                    Image.asset(
                      "assets/img/itour_logo.png",
                      width: 250, // Adjust size as needed
                      height: 250,
                    ),
                    const SizedBox(height: 60),

                    // Email field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white), // Email text color
                        decoration: InputDecoration(
                          hintText: "email",
                          hintStyle: const TextStyle(color: Colors.white70), // Hint color
                          prefixIcon: const Icon(Icons.person, color: Colors.white), // Icon color
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white), // Password text color
                        decoration: InputDecoration(
                          hintText: "password",
                          hintStyle: const TextStyle(color: Colors.white70), // Hint color
                          prefixIcon: const Icon(Icons.lock, color: Colors.white), // Icon color
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {},
                      child: Text("forgot password",
                          style: TextStyle(color: Colors.white70)),
                    ),

                    const SizedBox(height: 15),

                    // LOGIN → goes to MainTabs
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainTabs()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("LOGIN",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),

                    const SizedBox(height: 100),

                    GestureDetector(
                      onTap: () {},
                      child: Text("Don’t have an account? Register",
                          style: TextStyle(color: Colors.white70)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
