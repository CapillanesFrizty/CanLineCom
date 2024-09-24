import 'package:flutter/material.dart';

class Carddesign2Carousellist extends StatelessWidget {
  // Define constants for reuse
  static const double _borderRadius = 15.0;
  static const double _padding = 10.0;
  static const double _opacity = 0.2;
  final VoidCallback? goto;
  const Carddesign2Carousellist({super.key, this.goto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.0, // Fixed height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Keep horizontal scrolling
        itemCount: 10, // Set this to null for infinite items
        itemBuilder: (context, index) => _buildCard(index),
      ),
    );
  }

  // Method to build the card widget
  Widget _buildCard(int index) {
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
              _buildPositionedText(index),
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
      width: 300.0, // Set fixed width for each card in the horizontal list
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
  Widget _buildPositionedText(int index) {
    return Positioned(
      bottom: _padding, // Adjust text position
      left: _padding,
      right: _padding,
      child: _buildTextContainer(index),
    );
  }

  // Method to build the text container
  Widget _buildTextContainer(int index) {
    return Container(
      padding: const EdgeInsets.all(_padding), // Padding around text
      child: Text(
        'Blog Card $index', // Display index for infinite cards
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for contrast
        ),
      ),
    );
  }
}
