import 'package:flutter/material.dart';

class CardDesign1 extends StatelessWidget {
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
        SizedBox(height: 5),
        Text(
          secondaryText,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            //todo! need a color assignation between government and private hospital
            //todo! green for government red for private
          ),
        ),
      ],
    );
  }
}
