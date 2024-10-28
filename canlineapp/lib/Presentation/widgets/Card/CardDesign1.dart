import 'package:flutter/material.dart';

class CardDesign1 extends StatelessWidget {
  static const double _width = 146; // Fixed width for the card
  static const double _imageHeight = 122; // Height for the image
  static const double _cardHeight = 177; // Total height for the card
  final VoidCallback? goto;

  final String title;
  final String subtitle;
  final String image;

  const CardDesign1(
      {super.key,
      this.goto,
      required this.title,
      required this.subtitle,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: goto,
        child: Container(
          width: _width,
          height: _cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image.isNotEmpty)
                Image.network(image) // Use NetworkImage with the URL
              else
                Container(
                  height: 100, // Placeholder for missing image
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported),
                ),
              const SizedBox(height: 10),
              _cardTitleAndSecondaryText(
                title,
                subtitle,
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
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _width,
        height: _imageHeight,
        child: Image.network(
          image,
          fit: BoxFit.cover,
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
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Text(
          secondaryText,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
