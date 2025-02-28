import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/BarrelFileWidget..dart';

class Supportgroupslistscreen extends StatefulWidget {
  const Supportgroupslistscreen({super.key});

  @override
  State<Supportgroupslistscreen> createState() =>
      _SupportgroupslistscreenState();
}

class _SupportgroupslistscreenState extends State<Supportgroupslistscreen> {
  // Fetch data from Supabase
  Future<List<Map<String, dynamic>>> _fetchSupportGroups() async {
    try {
      final response =
          await Supabase.instance.client.from('Support_Groups').select();

      var supportGroups = List<Map<String, dynamic>>.from(response);

      // Apply search and filter logic
      if (_searchQuery.isNotEmpty) {
        supportGroups = supportGroups.where((group) {
          return group['Group_name']
                  ?.toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false;
        }).toList();
      }

      if (_selectedFilter != 'All') {
        supportGroups = supportGroups.where((group) {
          return group['Group_category'] == _selectedFilter;
        }).toList();
      }

      // Sort alphabetically
      supportGroups.sort((a, b) => (a['Group_name'] ?? '')
          .toString()
          .toLowerCase()
          .compareTo((b['Group_name'] ?? '').toString().toLowerCase()));

      // Generate image URLs
      for (var group in supportGroups) {
        if (group['Group_name'] != null) {
          try {
            // Debug print
            print('Processing group: ${group['Group_name']}');

            // Get image URL from the database if it exists
            final imageUrl = "${group['Group_name']}.png";
            if (imageUrl != null && imageUrl.toString().isNotEmpty) {
              final publicUrl = Supabase.instance.client.storage
                  .from('Assets')
                  .getPublicUrl("Support-Groups/$imageUrl");
              group['Support-Groups-Image-Url'] = publicUrl;
              print('Generated image URL: $imageUrl');
            } else {
              print('No image URL found for group: ${group['Group_name']}');
            }
          } catch (e) {
            print(
                'Error processing image for group ${group['Group_name']}: $e');
          }
        }
      }

      return supportGroups;
    } catch (e) {
      debugPrint('Error fetching support groups: $e');
      return [];
    }
  }

  // Constants
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  // Styles
  final _titleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 30.0,
      color: _primaryColor,
    ),
  );

  final _sectionTitleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: _primaryColor,
    ),
  );

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      // Reset search and filter if needed
      _searchQuery = '';
      _searchController.clear();
      _selectedFilter = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Enables refresh even when empty
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildSearchBar(), // Uncommented this line
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildSupportGroupsList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportGroupsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchSupportGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var supportGroups = snapshot.data ?? [];

        if (supportGroups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No support groups available'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshData,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: supportGroups.length,
          itemBuilder: (context, index) {
            final supportGroup = supportGroups[index];

            return CardDesign1(
              goto: () {
                if (supportGroup['id'] != null) {
                  GoRouter.of(context)
                      .push('/Support-Groups/${supportGroup['id'].toString()}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Unable to open support group details'),
                    ),
                  );
                }
              },
              image: supportGroup['Support-Groups-Image-Url'] ?? '',
              title: supportGroup['Group_name'] ?? 'No name',
              subtitle: supportGroup['Group_category'] ?? 'No category',
              location: supportGroup['Location'] ?? '',
              address: supportGroup['Address'] ?? '',
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Support Group Category',
                    style: TextStyle(color: _primaryColor),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<String>>(
                    future: _fetchCategories(),
                    builder: (context, snapshot) {
                      List<String> categories = ['All', ...?snapshot.data];

                      return DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        items: categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFilter = newValue ?? 'All';
                          });
                          this.setState(() {});
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filter',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<String>> _fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('Support_Groups')
          .select('Group_category');

      Set<String> uniqueCategories = {};
      for (var row in response) {
        if (row['Group_category'] != null) {
          uniqueCategories.add(row['Group_category']);
        }
      }

      return uniqueCategories.toList()..sort();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: _primaryColor),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list, color: _primaryColor),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
        ),
      ),
    );
  }
}
