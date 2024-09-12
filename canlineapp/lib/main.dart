import 'package:canerline_app/screen/homescreen/infohub.dart';

// import './screen/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Infohub(
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
