import 'package:flutter/material.dart';

class BlogPostLayout extends StatelessWidget {
  final String title;
  final String author;
  final String publishDate;
  final String content;
  final String imagePath; // Add an image path

  const BlogPostLayout({
    super.key,
    required this.title,
    required this.author,
    required this.publishDate,
    required this.content,
    required this.imagePath, // Add imagePath to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16), // Space before title

        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8), // Space between title and image

        // Image
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Optional: Add rounded corners to the image
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8), // Space between image and author/date

        // Author and date published with icons
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    publishDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border), // Change icon as needed
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share), // Change icon as needed
                    onPressed: () {
                      // Handle share action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16), // Space between author/date and content

        // Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(height: 16), // Space after content
      ],
    );
  }
}