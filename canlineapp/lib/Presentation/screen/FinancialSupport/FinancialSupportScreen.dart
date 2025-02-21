import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/Card/CardDesign1.dart';

class FinancialSupportScreen extends StatefulWidget {
  const FinancialSupportScreen({super.key});

  @override
  State<FinancialSupportScreen> createState() => _FinancialSupportScreenState();
}

class _FinancialSupportScreenState extends State<FinancialSupportScreen> {
  // Constants
  static const _primaryColor = Color(0xFF5B50A0);
  static const _secondaryColor = Color(0xFFF3EBFF);
  static const double _cardHeight = 200.0;

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
      fontSize: 18.0, // Match font size to BlogsScreen
      fontWeight: FontWeight.bold,
      color: _primaryColor,
    ),
  );

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final int _currentCategoryIndex = 0;

  // Add this variable to track the filter state
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text);
  }

  // Data Fetching
  Future<List<Map<String, dynamic>>> _fetchInstitutions() async {
    var query = Supabase.instance.client.from('Financial-Institution').select();

    // Apply filter if not 'All'
    if (_selectedFilter != 'All') {
      query = query.eq('Financial-Institution-Type', _selectedFilter);
    }

    final response = await query;
    List<Map<String, dynamic>> result = [];

    for (var institution in response) {
      if (institution['Financial-Institution-Name'] != null) {
        final fileName = "${institution['Financial-Institution-Name']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Financial-Institution/$fileName");

        institution['Financial-Institution-Image-Url'] = imageUrl;
        result.add(institution);
      }
    }

    // Apply search filter if query exists
    if (_searchQuery.isNotEmpty) {
      result = result.where((institution) {
        return institution['Financial-Institution-Name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  Future<void> _refreshInstitutions() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshInstitutions,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildInstitutionsList(),
                  ),
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

  Widget _buildInstitutionsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchInstitutions(),
      builder: (context, snapshot) {
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
                  onPressed: _refreshInstitutions,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final institutions = snapshot.data ?? [];
        if (institutions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No institutions found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshInstitutions,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: institutions.length,
          itemBuilder: (context, index) {
            final institution = institutions[index];
            return CardDesign1(
              goto: () => context.push(
                  '/Financial-Institution/${institution['Financial-Institution-ID']}'),
              image: institution['Financial-Institution-Image-Url'] ?? '',
              title: institution['Financial-Institution-Name'] ??
                  'Unknown Institution',
              subtitle:
                  institution['Financial-Institution-Type'] ?? 'Unknown Type',
              location: institution['Financial-Institution-Address'] ??
                  'No location available',
            );
          },
        );
      },
    );
  }

  // Add the filter bottom sheet method
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
                  Text('Institution Type',
                      style: TextStyle(color: _primaryColor)),
                  ToggleButtons(
                    isSelected: [
                      _selectedFilter == 'All',
                      _selectedFilter == 'Private Institution',
                      _selectedFilter == 'Government Institution'
                    ],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) _selectedFilter = 'All';
                        if (index == 1) _selectedFilter = 'Private Institution';
                        if (index == 2) {
                          _selectedFilter = 'Government Institution';
                        }
                      });
                      this.setState(() {}); // Update parent state
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
                        child: Text('Private'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Government'),
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
