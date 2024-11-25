import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OncologistsScreens extends StatefulWidget {
  const OncologistsScreens({super.key});

  @override
  State<OncologistsScreens> createState() => _OncologistsScreensState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _OncologistsScreensState extends State<OncologistsScreens> {
  final _getBlogs = Supabase.instance.client.from('Blogs').select();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
            const SizedBox(height: 30),
            _buildSearchBar(),
            const SizedBox(height: 30),
            _buildSectionTitle('Latest Events'),
            const SizedBox(height: 16),
            // _buildPopularBlogs(),
            // const SizedBox(height: 20),
            _buildSectionTitle('Other Events'),
            const SizedBox(height: 30),
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
          color: OncologistsScreens._primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon:
              const Icon(Icons.search, color: OncologistsScreens._primaryColor),
          suffixIcon: const Icon(Icons.filter_list,
              color: OncologistsScreens._primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
        ),
      ),
    );
  }

  // ? Parked for now, will be implemented in the future
  // Widget _buildLatestEvents) {
  //   return SizedBox(
  //     height: 200,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //       children: [
  //         _buildLatestEvents(
  //           date: 'Aug 7, 2024',
  //           title: 'Balancing the right treatments for metastatic cancer',
  //           author: 'Karl Wood',
  //         ),
  //         const SizedBox(width: 16),
  //         _buildLatestEvents(
  //           date: 'September 19, 2024',
  //           title: 'Therapy customized through stem cell treatments',
  //           author: 'Jane Doe',
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget _buildLatestEventsCard({

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
                      color: OncologistsScreens._primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    blogsdata['Blogs-Name'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: OncologistsScreens._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    blogsdata['Blog-Published'],
                    style: GoogleFonts.poppins(
                      color: OncologistsScreens._primaryColor,
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
