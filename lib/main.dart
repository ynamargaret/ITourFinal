import 'package:flutter/material.dart';
import 'main_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iTour',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainTabs(), // Start with the tabbed navigation
    );
  }
}
