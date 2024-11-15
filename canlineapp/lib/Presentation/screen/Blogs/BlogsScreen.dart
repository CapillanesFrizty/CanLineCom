import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(bottom: 20.0), // Extra padding for safety
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildSectionTitle('Popular'),
            const SizedBox(height: 16),
            _buildPopularBlogs(),
            const SizedBox(height: 20),
            _buildSectionTitle('Recent'),
            const SizedBox(height: 16),
            _buildRecentBlogs(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      color: BlogsScreen._primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Blogs', style: titleStyle),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(color: BlogsScreen._primaryColor),
          prefixIcon: Icon(Icons.search, color: BlogsScreen._primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BlogsScreen._primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BlogsScreen._primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: BlogsScreen._primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: BlogsScreen._primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPopularBlogs() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        children: [
          _buildPopularBlogCard(
            date: 'Aug 7, 2024',
            title: 'Balancing the right treatments for metastatic cancer',
            author: 'Karl Wood',
          ),
          const SizedBox(width: 16),
          _buildPopularBlogCard(
            date: 'September 19, 2024',
            title: 'Therapy customized through stem cell treatments',
            author: 'Jane Doe',
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBlogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ListView(
        shrinkWrap: true, // Allows the ListView to take only the needed space
        physics:
            NeverScrollableScrollPhysics(), // Prevents scrolling inside the main scroll view
        children: [
          _buildRecentBlogCard(
            category: 'Expert Opinions',
            title: 'Is hormone replacement therapy safe? An expert\'s opinion',
            date: 'September 17, 2024',
          ),
          _buildRecentBlogCard(
            category: 'Expert Opinions',
            title: 'Is hormone replacement therapy safe? An expert\'s opinion',
            date: 'September 17, 2024',
          ),
          _buildRecentBlogCard(
            category: 'Expert Opinions',
            title: 'Is hormone replacement therapy safe? An expert\'s opinion',
            date: 'September 17, 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBlogCard({
    required String date,
    required String title,
    required String author,
  }) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Icon(Icons.image, color: Colors.white70, size: 50),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Written by $author',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBlogCard({
    required String category,
    required String title,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white70, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.poppins(
                    color: BlogsScreen._primaryColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BlogsScreen._primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: BlogsScreen._primaryColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.favorite_border, color: BlogsScreen._primaryColor),
        ],
      ),
    );
  }
}
