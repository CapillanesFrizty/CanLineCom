import 'package:canerline_app/Presentation/widgets/Card/CardDesign3List.dart';
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
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Colors.white;

  final _future = Supabase.instance.client.from('Blogs').select();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ListView(
        children: [
          _buildTitle(),
          _buildSearchField(),
          _buildBlogTitle("New Blogs"),
          // _buildPopularBlogsList(context),
          _buildBlogTitle("Recent Blogs"),
          _buildRecentBlogs(context, _future),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      color: _primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Blogs', style: titleStyle),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: _secondaryColor,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(Icons.search, color: _primaryColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: _secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: _primaryColor, width: 1.5),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(color: _primaryColor, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildBlogTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5B50A0),
      ),
    );
  }

  //Todo! need new blogs data to able to design the Card
  // Widget _buildPopularBlogsList(BuildContext context) {
  //   return FutureBuilder(
  //     future: Supabase.instance.client
  //         .from('Blogs')
  //         .select()
  //         .order('views', ascending: false)
  //         .limit(3),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       final blogs = snapshot.data as List<Map<String, dynamic>>;
  //       return Column(
  //         children: blogs
  //             .map((blogData) => FutureBuilder<String>(
  //                   future: _getImageUrl(blogData['Blogs-Name']),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return const Center(child: CircularProgressIndicator());
  //                     }

  //                     final imageUrl = snapshot.data ?? '';
  //                     return GestureDetector(
  //                       onTap: () => context.go('/Blog/${blogData['Blog-ID']}'),
  //                       child: CardDesign3List(
  //                         title: blogData['Blogs-Name'] ?? 'Unknown',
  //                         category: blogData['Blogs-Category'] ?? 'Unknown',
  //                         date_published:
  //                             blogData['Blog-Published'] ?? 'Unknown',
  //                         ImgURL: imageUrl,
  //                       ),
  //                     );
  //                   },
  //                 ))
  //             .toList(),
  //       );
  //     },
  //   );
  // }
//Todo! need to work on UI in Blogs Card
  Widget _buildRecentBlogs(
      BuildContext context, Future<List<Map<String, dynamic>>> blogsFuture) {
    return FutureBuilder(
      future: blogsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error fetching data',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }

        final List<Map<String, dynamic>> blogs = snapshot.data ?? [];

        if (blogs.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.article_outlined,
                    size: 40, color: _primaryColor),
                const SizedBox(height: 16),
                Text(
                  'No blogs available',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: blogs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final blogData = blogs[index];
            return FutureBuilder<String>(
              future: _getImageUrl(blogData['Blogs-Name']),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => context.go('/Blog/${blogData['Blog-ID']}'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CardDesign3List(
                      category: blogData['Blogs-Category'] ?? 'Unknown',
                      date_published: blogData['Blog-Published'] ?? 'Unknown',
                      ImgURL: imageSnapshot.data ?? '',
                      title: blogData['Blogs-Name'] ?? 'Unknown Name',
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> _getImageUrl(String blogName) async {
    final fileName = "$blogName.png";
    final response = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Blogs-News/$fileName");
    return response;
  }
}
