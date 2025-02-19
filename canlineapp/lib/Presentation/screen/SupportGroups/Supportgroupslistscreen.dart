import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/BarrelFileWidget..dart';

class Supportgroupslistscreen extends StatefulWidget {
  const Supportgroupslistscreen({super.key});

  static final List<Map<String, String>> supportGroups = [
    {
      'name': 'Philippine Cancer Society',
      'description':
          'The Philippine Cancer Society provides support and resources for cancer patients, including educational materials, counseling, and financial assistance.',
      'members': '100 members',
      'url': 'https://www.philcancer.org.ph/'
    },
    {
      'name': 'Cancer Warriors Foundation',
      'description':
          'Cancer Warriors Foundation supports children with cancer and their families through medical assistance, emotional support, and advocacy programs.',
      'members': '50 members',
      'url': 'https://www.c-warriors.org/'
    },
    {
      'name': 'ICanServe Foundation',
      'description':
          'ICanServe Foundation focuses on breast cancer awareness and support, offering early detection programs, patient navigation, and community-based support groups.',
      'members': '75 members',
      'url': 'https://www.icanservefoundation.org/'
    },
    {
      'name': 'Carewell Community',
      'description':
          'Carewell Community provides comprehensive support and resources for cancer patients and their families, including counseling, support groups, and wellness programs.',
      'members': '60 members',
      'url': 'https://www.carewellcommunity.org/'
    },
    {
      'name': 'Project: Brave Kids',
      'description':
          'Project: Brave Kids supports children with cancer and their families by providing medical assistance, emotional support, and educational resources.',
      'members': '40 members',
      'url': 'https://www.projectbravekids.org/'
    },
  ];

  @override
  State<Supportgroupslistscreen> createState() =>
      _SupportgroupslistscreenState();
}

class _SupportgroupslistscreenState extends State<Supportgroupslistscreen> {
  static const Color _primaryColor = Color(0xFF5B50A0);

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
    setState(() {});
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
        child: Column(
          children: [
            _buildSearchBarWithFilter(),
            const SizedBox(height: 30),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: _buildSupportGroupsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarWithFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: _primaryColor),
          suffixIcon: PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: _primaryColor),
            onSelected: (String newValue) {
              setState(() {
                _selectedFilter = newValue;
              });
            },
            itemBuilder: (BuildContext context) {
              return <String>['All', 'Cancer', 'Others'].map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
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
    return ListView.builder(
      itemCount: filteredSupportGroups.length,
      itemBuilder: (context, index) {
        final supportGroup = filteredSupportGroups[index];
        return CardDesign1(
          goto: () {
            context.push('/Support-Groups/${supportGroup['name']}');
          },
          image: '', // Add image URL if available
          title: supportGroup['name']!,
          subtitle: supportGroup['description']!,
        );
      },
    );
  }
}
