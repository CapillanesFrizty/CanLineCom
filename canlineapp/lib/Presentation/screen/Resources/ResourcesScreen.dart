import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/Card/CardDesign1.dart';

class ResourcesScreen extends StatefulWidget {
  final String userid;
  const ResourcesScreen({super.key, required this.userid});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedType = 'All'; // Can be 'All', 'Events', 'Blogs'

  Future<List<Map<String, dynamic>>> getBlogs() async {
    try {
      final response = await Supabase.instance.client.from('Blogs').select();
      if (response.isEmpty) return [];

      final blogs = response as List<dynamic>;
      for (var blog in blogs) {
        final fileName = "${blog['Blogs-Name']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Blogs-News/$fileName");
        blog['im'] = imageUrl;
      }

      final filteredBlogs = blogs.where((blog) {
        return blog['Blogs-Name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();

      return filteredBlogs.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error fetching blogs: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response = await Supabase.instance.client.from('Events').select();
      if (response.isEmpty) return [];

      final events = response as List<dynamic>;
      return events
          .where((event) {
            return event['Event_name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          })
          .toList()
          .cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Added SafeArea
        child: RefreshIndicator(
          onRefresh: _refreshContent,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildTypeFilter(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildContentList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
              const Icon(Icons.search, color: ResourcesScreen._primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ResourcesScreen._primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ResourcesScreen._primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ResourcesScreen._primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Row(
        children: [
          _filterChip('All'),
          const SizedBox(width: 10),
          _filterChip('Events'),
          const SizedBox(width: 10),
          _filterChip('Blogs'),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedType == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedType = label;
        });
      },
      backgroundColor:
          isSelected ? ResourcesScreen._secondaryColor : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected
            ? ResourcesScreen._secondaryColor
            : ResourcesScreen._primaryColor,
      ),
      selectedColor: ResourcesScreen._primaryColor,
      checkmarkColor: ResourcesScreen._secondaryColor, // Added checkmark color
    );
  }

  Widget _buildContentList() {
    return FutureBuilder(
      future: Future.wait([
        if (_selectedType == 'All' || _selectedType == 'Events') getEvents(),
        if (_selectedType == 'All' || _selectedType == 'Blogs') getBlogs(),
      ]),
      builder:
          (context, AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No Internet Connection'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshContent,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        List<Map<String, dynamic>> combinedData = [];
        if (snapshot.data != null) {
          for (var dataList in snapshot.data!) {
            combinedData.addAll(dataList);
          }
        }

        if (combinedData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No content available'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshContent,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: combinedData.length,
          itemBuilder: (context, index) {
            final item = combinedData[index];
            if (item.containsKey('Event_name')) {
              return _buildEventCard(item);
            } else {
              return _buildBlogCard(item);
            }
          },
        );
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> eventData) {
    return CardDesign1(
      goto: () =>
          context.go('/${widget.userid}/event/${eventData['Event_id']}'),
      image: '',
      title: eventData['Event_name'] ?? 'Unknown Event',
      subtitle: 'Event', // Changed to display "Event" as category
      location: 'Date: ${eventData['Event_Date'] ?? 'TBA'}',
      address: 'Time: ${eventData['Event_Time'] ?? 'TBA'}',
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blogData) {
    return CardDesign1(
      goto: () => context.go('/${widget.userid}/blog/${blogData['Blog-ID']}'),
      image: blogData['im'] ?? '',
      title: blogData['Blogs-Name'] ?? 'Unknown Title',
      subtitle: 'Blog', // Changed to display "Blog" as category
      location: 'Published: ${blogData['Blog-Published'] ?? 'Unknown Date'}',
      address: '', // Keep empty for blogs
    );
  }
}
