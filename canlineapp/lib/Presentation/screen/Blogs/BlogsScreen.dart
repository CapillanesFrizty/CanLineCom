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
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  Future<List<Map<String, dynamic>>> getBlogs() async {
    try {
      final response = await Supabase.instance.client.from('Blogs').select();
      if (response.isEmpty) {
        return [];
      }

      final blogs = response as List<dynamic>;

      for (var blog in blogs) {
        final fileName = "${blog['Blogs-Name']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Blogs-News/$fileName");
        blog['im'] = imageUrl;
      }

      // Filter blogs based on search query and category
      final filteredBlogs = blogs.where((blog) {
        final matchesQuery = blog['Blogs-Name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            blog['Blogs-Category'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();

      return filteredBlogs.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error fetching blogs: $e');
      return [];
    }
  }

  Future<void> _refreshBlogs() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search',
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    <String>['All', 'Blog', 'News'].map((String category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = selected ? category : 'All';
                        });
                      },
                      selectedColor: BlogsScreen._primaryColor,
                      backgroundColor: BlogsScreen._secondaryColor,
                      labelStyle: TextStyle(
                        color: _selectedCategory == category
                            ? Colors.white
                            : BlogsScreen._primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshBlogs,
              child: FutureBuilder(
                future: getBlogs(),
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
                    itemCount: blogsdata.length,
                    itemBuilder: (context, index) {
                      return _buildBlogCard(blogsdata[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blogsdata) {
    return GestureDetector(
      onTap: () {
        context.go('/Blog/${blogsdata['Blog-ID']}');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blogsdata['im'] != null && blogsdata['im'] != '')
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  blogsdata['im'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blogsdata['Blogs-Category'] ?? '',
                    style: GoogleFonts.poppins(
                      color: BlogsScreen._primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blogsdata['Blogs-Name'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BlogsScreen._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blogsdata['Blog-Published'] ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
