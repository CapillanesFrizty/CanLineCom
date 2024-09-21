import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardDesign1 extends StatelessWidget {
  static const double _width = 146; // Fixed width for the card
  static const double _imageHeight = 122; // Height for the image
  static const double _cardHeight = 177; // Total height for the card

  const CardDesign1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          // Handle tap, e.g., navigate to another screen
          context.go('/Health-Insititution/More-Info');
        },
        child: Container(
          width: _width, // Fixed width
          height: _cardHeight, // Fixed height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent, // Background color
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardImage('lib/assets/images/jpeg/spmc.jpg'), // Image
              const SizedBox(height: 10), // Space between image and text
              _cardTitleAndSecondaryText(
                'Sylhet MAG Osmani Medical College',
                'Government Hospital',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the card Media (Image)
  Widget _cardImage(String image) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(10), // Match with the card's border radius
      child: SizedBox(
        width: _width, // Match the card width
        height: _imageHeight, // Set image height
        child: Image.asset(
          image,
          fit: BoxFit.cover, // Cover the entire container
        ),
      ),
    );
  }

  // Method to build the card Title and Secondary Text
  Widget _cardTitleAndSecondaryText(String title, String secondaryText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Darker color for better contrast
          ),
        ),
        SizedBox(height: 5),
        Text(
          secondaryText,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.grey, // Subtle color for secondary text
          ),
        ),
      ],
    );
  }
}
