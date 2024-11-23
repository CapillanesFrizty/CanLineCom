import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _BlogsScreenState extends State<BlogsScreen> {
  final _getBlogs = Supabase.instance.client.from('Blogs').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Blogs',
          style: GoogleFonts.poppins(
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
            color: BlogsScreen._primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BlogsScreen._primaryColor),
          onPressed: () {
            context.go('/homescreen/:userID');
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(bottom: 20.0), // Extra padding for safety
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // _buildSectionTitle('Popular'),
            // const SizedBox(height: 16),
            // _buildPopularBlogs(),
            // const SizedBox(height: 20),
            _buildSectionTitle('Recent'),
            const SizedBox(height: 16),
            _buildRecentBlogs(),
          ],
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

  // ? Parked for now, will be implemented in the future
  // Widget _buildPopularBlogs() {
  //   return SizedBox(
  //     height: 200,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //       children: [
  //         _buildPopularBlogCard(
  //           date: 'Aug 7, 2024',
  //           title: 'Balancing the right treatments for metastatic cancer',
  //           author: 'Karl Wood',
  //         ),
  //         const SizedBox(width: 16),
  //         _buildPopularBlogCard(
  //           date: 'September 19, 2024',
  //           title: 'Therapy customized through stem cell treatments',
  //           author: 'Jane Doe',
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget _buildPopularBlogCard({

  Widget _buildRecentBlogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: FutureBuilder(
        future: _getBlogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          final blogsdata = snapshot.data as List<Map<String, dynamic>>;
          if (blogsdata.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blogsdata.length,
            itemBuilder: (context, index) {
              return _buildRecentBlogCard(blogsdata[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentBlogCard(Map<String, dynamic> blogsdata) {
    return GestureDetector(
      onTap: () {
        context.go('/Blog/${blogsdata['Blog-ID']}');
      },
      child: Container(
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
                    blogsdata['Blogs-Category'],
                    style: GoogleFonts.poppins(
                      color: BlogsScreen._primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    blogsdata['Blogs-Name'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BlogsScreen._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    blogsdata['Blog-Published'],
                    style: GoogleFonts.poppins(
                      color: BlogsScreen._primaryColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: 15),
            // Icon(Icons.favorite_border, color: BlogsScreen._primaryColor),
          ],
        ),
      ),
    );
  }
}
