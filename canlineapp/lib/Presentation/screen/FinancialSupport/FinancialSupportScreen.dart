import 'dart:async';
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
  final String _selectedFilter = 'All';

  // Add to state class
  final List<String> _selectedInstitutionTypes = [];

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

    if (_selectedInstitutionTypes.isNotEmpty &&
        !_selectedInstitutionTypes.contains('All')) {
      query = query.inFilter(
          'Financial-Institution-Type', _selectedInstitutionTypes);
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
    return FutureBuilder(
      future: _checkInternetConnection(),
      builder: (context, internetSnapshot) {
        if (internetSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (internetSnapshot.data == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Internet Connection',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your network and try again',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _refreshContent,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
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
                  isVerified: institution['isverified'] ?? false,
                );
              },
            );
          },
        );
      },
    );
  }

  // Replace _showFilterBottomSheet method with this updated version
  void _showFilterBottomSheet(BuildContext context) {
    final List<Map<String, List<String>>> filterCategories = [
      {
        'Institution Types': [
          'All',
          'Private Institution',
          'Government Institution',
          'Partylist'
        ],
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Institutions',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: _primaryColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filterCategories.length,
                          itemBuilder: (context, index) {
                            final category = filterCategories[index];
                            final title = category.keys.first;
                            final options = category.values.first;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...options.map((type) {
                                  return CheckboxListTile(
                                    title: Text(
                                      type,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: _selectedInstitutionTypes
                                        .contains(type),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          if (type == 'All') {
                                            _selectedInstitutionTypes.clear();
                                          } else {
                                            _selectedInstitutionTypes
                                                .remove('All');
                                          }
                                          _selectedInstitutionTypes.add(type);
                                        } else {
                                          _selectedInstitutionTypes
                                              .remove(type);
                                        }
                                      });
                                    },
                                    activeColor: _primaryColor,
                                    checkColor: Colors.white,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                }).toList(),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedInstitutionTypes.clear();
                                  _selectedInstitutionTypes.add('All');
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: _primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.poppins(
                                  color: _primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                this.setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Apply Filters',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
