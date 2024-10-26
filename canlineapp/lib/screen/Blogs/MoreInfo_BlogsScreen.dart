import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Layouts/BarrelFileLayouts.dart';

class MoreinfoBlogsscreen extends StatefulWidget {
  final String id;
  const MoreinfoBlogsscreen({super.key, required this.id});

  @override
  State<MoreinfoBlogsscreen> createState() => _MoreinfoBlogsscreenState();
}

class _MoreinfoBlogsscreenState extends State<MoreinfoBlogsscreen> {
  late Future<Map<String, dynamic>> _future;

  Future<Map<String, dynamic>> _fetchBlogs() async {
    final response = await Supabase.instance.client
        .from('Blogs, Blogs-RefLink("Blog-ID")')
        .select()
        .eq('Blog-ID', widget.id)
        .single();

    // Generate image URL
    final fileName = "${response['Blogs-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Blogs-News/$fileName");

    response['Blog-Image-Url'] = imageUrl;

    return response;
  }

  @override
  void initState() {
    super.initState();
    _future = _fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data!;
            return BlogPostLayout(
              imagePath: data['Blog-Image-Url'] ?? '',
              title: data['Blogs-Title'] ?? 'No Title Available',
              author: data['Blogs-Author'] ?? 'No Author Available',
              publishDate: 'September 24, 2024',
              content: data['Blogs-Content'] ?? 'No Content Available',
            );
          },
        ),
      ),
    );
  }
}
