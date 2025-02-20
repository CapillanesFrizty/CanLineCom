import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Layouts/BarrelFileLayouts.dart';

class MoreinfoBlogsscreen extends StatefulWidget {
  final String id;
  final String userid;
  const MoreinfoBlogsscreen(
      {super.key, required this.id, required this.userid});

  @override
  State<MoreinfoBlogsscreen> createState() => _MoreinfoBlogsscreenState();
}

class _MoreinfoBlogsscreenState extends State<MoreinfoBlogsscreen> {
  late Future<Map<String, dynamic>> _blogData;

  @override
  void initState() {
    super.initState();
    _blogData = _fetchBlogData();
  }

  /// Fetches blog data from the Supabase database.
  /// Fetches blog data from the Supabase database.
  Future<Map<String, dynamic>> _fetchBlogData() async {
    final response = await Supabase.instance.client
        .from('Blogs')
        .select(
            'Blog-ID, Blogs-Name, Blogs-Author, Blogs-Content, Blog-Published, Blogs-RefLink(Blog-ID, Blogs-Link)')
        .eq('Blog-ID', widget.id)
        .single();

    // Print the full response to inspect its structure
    debugPrint('Supabase Response: $response');

    response['Blog-Image-Url'] = await _getImageUrl(response);
    return response;
  }

  /// Fetches the image URL from Supabase storage based on the blog name.
  Future<String> _getImageUrl(Map<String, dynamic> blogData) async {
    final fileName = "${blogData['Blogs-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Blogs-News/$fileName");
    debugPrint("imgURL: $imageUrl");
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: const Color(0xFF5B50A0),
          onPressed: () => context.go(
              '/HomeScreen/${widget.userid}/resources'), // Simplified navigation
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _blogData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5B50A0), // Added consistent color
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _blogData = _fetchBlogData();
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final blogRefLink = data['Blogs-RefLink'] as List<dynamic>?;
            final blogLink = (blogRefLink != null && blogRefLink.isNotEmpty)
                ? blogRefLink[0]['Blogs-Link'] ?? 'No Link Available'
                : 'No Link Available';

            return BlogPostLayout(
              imagePath: data['Blog-Image-Url'] ?? '',
              title: data['Blogs-Name'] ?? 'No Title Available',
              author: data['Blogs-Author'] ?? 'No Author Available',
              publishDate: data['Blog-Published'] ?? 'No Date Available',
              content: data['Blogs-Content'] ?? 'No Content Available',
              link: [blogLink],
            );
          },
        ),
      ),
    );
  }
}
