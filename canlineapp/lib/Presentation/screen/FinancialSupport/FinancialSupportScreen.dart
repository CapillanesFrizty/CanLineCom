import 'dart:io';

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

    result.sort((a, b) => (a['Financial-Institution-Name'] as String)
        .compareTo(b['Financial-Institution-Name'] as String));

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

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Widget _buildInstitutionsList() {
    return FutureBuilder(
        future: _checkInternetConnection(),
        builder: (context, internetSnapshot) {
          if (internetSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (internetSnapshot.error is SocketException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'No internet connection. Please check your network and try again.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshContent,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

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
                      const Text(
                          'We’re experiencing technical issues. Please try again later'),
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
                      const Text('No data available. Please check back later'),
                      const SizedBox(height: 16),
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
                    goto: () => GoRouter.of(context).push(
                        '/Financial-Institution/${institution['Financial-Institution-ID']}'),
                    image: institution['Financial-Institution-Image-Url'] ?? '',
                    title: institution['Financial-Institution-Name'] ??
                        'Unknown Institution',
                    subtitle: institution['Financial-Institution-Type'] ??
                        'Unknown Type',
                    location: institution['Financial-Institution-Address'] ??
                        'No location available',
                  );
                },
              );
            },
          );
        });
  }

  // Add the filter bottom sheet method
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Institution Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _filterChip('All', _selectedFilter == 'All', (selected) {
                        setState(() => _selectedFilter = 'All');
                        this.setState(() {});
                      }),
                      _filterChip(
                        'Private Institution',
                        _selectedFilter == 'Private Institution',
                        (selected) {
                          setState(
                              () => _selectedFilter = 'Private Institution');
                          this.setState(() {});
                        },
                      ),
                      _filterChip(
                        'Government Institution',
                        _selectedFilter == 'Government Institution',
                        (selected) {
                          setState(
                              () => _selectedFilter = 'Government Institution');
                          this.setState(() {});
                        },
                      ),
                      _filterChip(
                        'Partylist',
                        _selectedFilter == 'Partylist',
                        (selected) {
                          setState(() => _selectedFilter = 'Partylist');
                          this.setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterChip(String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: _primaryColor.withOpacity(0.2),
      checkmarkColor: _primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? _primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? _primaryColor : Colors.grey.shade300,
        ),
      ),
    );
  }
}
