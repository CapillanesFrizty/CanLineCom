import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:canerline_app/widgets/onboarding/getstarted_button.dart'; // Update the import path as needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Initial opacity value
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeIn();
  }

  void _fadeIn() {
    setState(() {
      _opacity = 1.0; // Fade in
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: SvgPicture.asset('lib/assets/images/logo/introduction.svg'), // Display image with opacity animation
            ),
            const SizedBox(height: 20), // Add some space between the image and the text
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: const Text(
                'With you, through every step',
                style: TextStyle(
                  color: Color(0xFF5B50A0),
                  fontSize: 19,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some space between the text and the button
            const GetstartedButton(), // Use the GetstartedButton widget
          ],
        ),
      ),
    );
  }
}