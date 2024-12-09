import 'package:flutter/material.dart';

class CardDesign1 extends StatelessWidget {
  final VoidCallback? goto;
  final String title;
  final String subtitle;
  final String image;

  const CardDesign1({
    super.key,
    this.goto,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: goto,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    12.0), // Rounded corners for the image
                child: Image.network(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit
                      .cover, // Ensure the image fills the space proportionally
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  height: 120, // Placeholder for missing image
                  width: double.infinity,
                  color: Colors.grey,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            _cardTitleAndSecondaryText(
              title,
              subtitle,
            ),
          ],
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
            color: Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          secondaryText,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: _getSubtitleColor(secondaryText),
          ),
        ),
      ],
    );
  }

  /// Determines the color for the subtitle based on the type
  Color _getSubtitleColor(String secondaryText) {
    if (secondaryText.toLowerCase().contains("government")) {
      return Colors.green; // Green for government hospitals
    } else if (secondaryText.toLowerCase().contains("private")) {
      return Colors.red; // Red for private hospitals
    }
    return Colors.grey; // Default color for other cases
  }
}
