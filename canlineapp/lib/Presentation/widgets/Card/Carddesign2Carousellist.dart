import 'package:flutter/material.dart';

class Carddesign2Carousellist extends StatelessWidget {
  // Define constants for reuse
  static const double _borderRadius = 15.0;
  static const double _opacity = 0.2;
  final VoidCallback? goto;
  final String image;
  final String title;
  final String category; // Add this line

  const Carddesign2Carousellist({
    super.key,
    this.goto,
    required this.title,
    required this.image,
    required this.category, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goto,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Stack(
          children: [
            _buildImage(),
            _buildOverlay(),
            _buildPositionedText(title),
            _buildCategoryLabel(category), // Add this line
          ],
        ),
      ),
    );
  }

  // Method to build the image widget
  Widget _buildImage() {
    return image.isNotEmpty
        ? Center(
            child: Image.network(
              image,
              fit: BoxFit.cover,
              height: 300.0,
              width: 300.0, // Set fixed width for each card
            ),
          )
        : Container(
            height: 300.0, // Placeholder for missing image
            width: 300.0, // Set fixed width for each card
            color: Colors.grey,
            child: Icon(Icons.image_not_supported),
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
      bottom: 10.0, // Adjust text position
      left: 10.0,
      right: 10.0,
      child: _buildTextContainer(title),
    );
  }

  // Method to build the text container
  Widget _buildTextContainer(String title) {
    return Container(
      padding: const EdgeInsets.all(10.0), // Padding around text
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Method to build the category label
  Widget _buildCategoryLabel(String category) {
    return Positioned(
      top: 10.0, // Adjust label position
      left: 10.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          category,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
