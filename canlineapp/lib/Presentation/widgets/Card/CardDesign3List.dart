import 'package:flutter/material.dart';

class CardDesign3List extends StatelessWidget {
  const CardDesign3List({
    super.key,
    required this.title,
    required this.ImgURL,
    required this.date_published,
    required this.category,
  });

  final String title;
  final String ImgURL;
  final String date_published;
  final String category;

  static const double _borderRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  // Method to build each card
  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(
          vertical: 8.0), // Added spacing between cards
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns content to the top
        children: [
          _buildImage(ImgURL), // Image on the left side
          Expanded(child: _buildCardDetails(title)), // Text on the right side
        ],
      ),
    );
  }

  // Method to build the image widget
  Widget _buildImage(String imgURL) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_borderRadius),
        bottomLeft: Radius.circular(_borderRadius),
      ),
      child: Image.network(
        imgURL, // Image URL
        fit: BoxFit.cover,
        height: 145.0,
        width: 130.0, // Fixed width for the image
      ),
    );
  }

  // Method to build the entire card details
  Widget _buildCardDetails(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Added padding around text content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align text to the left
        children: [
          _buildExpertOpinionRow(category),
          const SizedBox(height: 8.0), // Spacing between elements
          _buildTitle(title),
          const SizedBox(height: 8.0),
          _buildDate(date_published),
        ],
      ),
    );
  }

  // Method to build the expert opinion row with text and icon
  Widget _buildExpertOpinionRow(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildExpertOpinionText(category),
        ),
        _buildFavoriteIcon(), // Call the new widget for the icon
      ],
    );
  }

  // Widget for the expert opinion text
  Widget _buildExpertOpinionText(String category) {
    return Text(
      category,
      style: const TextStyle(
        fontSize: 12.0, // Adjusted font size to better match the design
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
      overflow: TextOverflow.ellipsis, // Ensures text doesn’t overflow
    );
  }

  // New widget for the favorite icon
  Widget _buildFavoriteIcon() {
    return IconButton(
      icon: const Icon(Icons.favorite_border,
          color: Colors.purple), // Updated icon color to purple
      onPressed: () {
        // Add functionality if needed
      },
    );
  }

  // Method to build the title
  Widget _buildTitle(String title) {
    return Text(
      title, // Title
      maxLines: 2, // Restrict title to 2 lines for consistency
      overflow: TextOverflow.ellipsis, // Ellipsis if title is too long
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Method to build the date
  Widget _buildDate(String date_published) {
    return Text(
      date_published, // Date
      style: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
  }
}
