import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/BarrelFileWidget..dart';

class Supportgroupslistscreen extends StatefulWidget {
  const Supportgroupslistscreen({super.key});

  static final List<Map<String, String>> supportGroups = [
    {
      'name': 'Philippine Cancer Society',
      'description':
          'The Philippine Cancer Society provides support and resources for cancer patients, including educational materials, counseling, and financial assistance.',
      'category': 'General Cancer Support',
      'members': '100 members',
      'url': 'https://www.philcancer.org.ph/'
    },
    {
      'name': 'Cancer Warriors Foundation',
      'description':
          'Cancer Warriors Foundation supports children with cancer and their families through medical assistance, emotional support, and advocacy programs.',
      'category': 'Pediatric Cancer Support',
      'members': '50 members',
      'url': 'https://www.c-warriors.org/'
    },
    {
      'name': 'ICanServe Foundation',
      'description':
          'ICanServe Foundation focuses on breast cancer awareness and support, offering early detection programs, patient navigation, and community-based support groups.',
      'category': 'Breast Cancer Support',
      'members': '75 members',
      'url': 'https://www.icanservefoundation.org/'
    },
    {
      'name': 'Carewell Community',
      'description':
          'Carewell Community provides comprehensive support and resources for cancer patients and their families, including counseling, support groups, and wellness programs.',
      'category': 'Family Support & Wellness',
      'members': '60 members',
      'url': 'https://www.carewellcommunity.org/'
    },
    {
      'name': 'Project: Brave Kids',
      'description':
          'Project: Brave Kids supports children with cancer and their families by providing medical assistance, emotional support, and educational resources.',
      'category': 'Pediatric Cancer Support',
      'members': '40 members',
      'url': 'https://www.projectbravekids.org/'
    },
  ];

  @override
  State<Supportgroupslistscreen> createState() =>
      _SupportgroupslistscreenState();
}

class _SupportgroupslistscreenState extends State<Supportgroupslistscreen> {
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

  List<Map<String, String>> _getFilteredSupportGroups() {
    return Supportgroupslistscreen.supportGroups.where((group) {
      final matchesSearchQuery =
          group['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Cancer' &&
              group['description']!.toLowerCase().contains('cancer')) ||
          (_selectedFilter == 'Others' &&
              !group['description']!.toLowerCase().contains('cancer'));
      return matchesSearchQuery && matchesFilter;
    }).toList();
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
                  _buildSearchBar(),
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

  Widget _buildSupportGroupsList() {
    final filteredSupportGroups = _getFilteredSupportGroups();

    if (filteredSupportGroups.isEmpty) {
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
      itemCount: filteredSupportGroups.length,
      itemBuilder: (context, index) {
        final supportGroup = filteredSupportGroups[index];
        return CardDesign1(
          goto: () {
            final encodedName = Uri.encodeComponent(supportGroup['name']!);
            context.go('/Support-Groups/$encodedName');
          },
          image: '', // Add image URL if available
          title: supportGroup['name']!,
          subtitle: supportGroup['category'] ?? 'No category',
          location: '', // Add if you have location data
          address: '', // Add if you have address data
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
                  Text('Filter',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor)),
                  SizedBox(height: 16),
                  Text('Support Group Type',
                      style: TextStyle(color: _primaryColor)),
                  ToggleButtons(
                    isSelected: [
                      _selectedFilter == 'All',
                      _selectedFilter == 'Cancer',
                      _selectedFilter == 'Others'
                    ],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) _selectedFilter = 'All';
                        if (index == 1) _selectedFilter = 'Cancer';
                        if (index == 2) _selectedFilter = 'Others';
                      });
                      this.setState(() {});
                    },
                    selectedColor: Colors.white,
                    color: Colors.grey,
                    fillColor: _primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('All'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Cancer'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Others'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters',
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
}
