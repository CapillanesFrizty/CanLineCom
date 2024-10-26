import 'package:canerline_app/widgets/Card/CardDesign3List.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  // Future to get blogs from Supabase
  final _future = Supabase.instance.client.from('Blogs').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchField(),
            _buildSectionTitle("Popular Blogs"),
            _buildPopularBlogsList(context),
            _buildSectionTitle("Recent Blogs"),
            _buildRecentBlogs(context, _future), // Passing future here
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        "Blogs",
        style: GoogleFonts.poppins(
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B50A0),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B50A0),
        ),
      ),
    );
  }

  Widget _buildPopularBlogsList(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.go('/Blog/More-Info-Blogs'),
            child: Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Popular Blog ${index + 1}',
                  style: GoogleFonts.poppins(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBlogs(
      BuildContext context, Future<List<Map<String, dynamic>>> blogsFuture) {
    return FutureBuilder(
      future: blogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        final List<Map<String, dynamic>> blog = snapshot.data ?? [];

        if (blog.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true, // Prevents scrolling conflicts
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blog.length,
              itemBuilder: (context, index) {
                final blogData = blog[index];
                return GestureDetector(
                  onTap: () => context.go('/Blog/More-Info-Blogs'),
                  child: CardDesign3List(
                    title: blogData['Blogs-Name'] ?? 'Unknown Name',
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
