import 'package:flutter/material.dart';

class Carddesign2Carousellist extends StatelessWidget {
  // Define constants for reuse
  static const double _borderRadius = 15.0;
  static const double _padding = 10.0;
  static const double _opacity = 0.2;
  final VoidCallback? goto;

  final String title;

  const Carddesign2Carousellist({super.key, this.goto, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 10.0), // Space between cards
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        elevation: 4.0, // Adds a shadow effect
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Stack(
            children: [
              _buildImage(),
              _buildOverlay(),
              _buildPositionedText(title),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the image widget
  Widget _buildImage() {
    return Image.asset(
      'lib/assets/images/jpeg/spmc.jpg',
      fit: BoxFit.cover, // Ensures the image fits properly
      height: 200.0,
      width: 400.0, // Set fixed width for each card in the horizontal list
    );
  }

  // Method to build the semi-transparent overlay
  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(_opacity), // Overlay with 20% opacity
      ),
    );
  }

  // Method to build the positioned text widget
  Widget _buildPositionedText(String title) {
    return Positioned(
      bottom: _padding, // Adjust text position
      left: _padding,
      right: _padding,
      child: _buildTextContainer(title),
    );
  }

  // Method to build the text container
  Widget _buildTextContainer(String title) {
    return Container(
      padding: const EdgeInsets.all(_padding), // Padding around text
      child: Text(
        title, // Display index for infinite cards
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for contrast
        ),
      ),
    );
  }
}
