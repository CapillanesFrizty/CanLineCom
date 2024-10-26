import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Layouts/BarrelFileLayouts.dart';

class MoreinfoBlogsscreen extends StatefulWidget {
  const MoreinfoBlogsscreen({super.key});

  @override
  State<MoreinfoBlogsscreen> createState() => _MoreinfoBlogsscreenState();
}

class _MoreinfoBlogsscreenState extends State<MoreinfoBlogsscreen> {
  final _future = Supabase.instance.client
      .from('Blogs, Blogs-RefLink("Blog-ID")')
      .select()
      .eq('Blog-ID', '1')
      .single();

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
              imagePath: 'lib/assets/images/jpeg/spmc.jpg',
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
