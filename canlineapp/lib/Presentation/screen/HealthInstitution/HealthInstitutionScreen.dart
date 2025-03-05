import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/BarrelFileWidget..dart';

class HealthInstitutionScreen extends StatefulWidget {
  final String? userid;
  const HealthInstitutionScreen({super.key, this.userid});

  @override
  State<HealthInstitutionScreen> createState() =>
      _HealthInstitutionScreenState();
}

class _HealthInstitutionScreenState extends State<HealthInstitutionScreen> {
  static const Color _primaryColor = Color(0xFF5B50A0);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentCategoryIndex =
      0; // Track current category (0: Hospitals, 1: Clinics, 2: Brgy. HS)
  // String _selectedFilter = 'All';
  String _selectedtreatmentType = 'All';
  // bool _is24Hours = false;
  // bool _hasEmergencyServices = false;
  final List<String> _selectedInsurance = [];

  // Add specialty options
  final List<String> specialties = [
    'All',
    'Cancer Care',
    'Cardiology',
    'Pediatrics',
    'General Medicine',
    'Surgery',
    'Obstetrics & Gynecology',
  ];

  // Add insurance options
  final List<String> insuranceProviders = [
    'PhilHealth',
    'HMO',
    'Private Insurance',
  ];

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

  // Get the health institutions data
  Future<List<Map<String, dynamic>>> _getHealthInstitutionData() async {
    var query = Supabase.instance.client.from('Health-Institution').select();

    // Service Type is now handled by category selection
    if (_currentCategoryIndex == 1) {
      query = query.eq('Treatment-Type', 'Outpatient');
    } else if (_currentCategoryIndex == 2) {
      query = query.eq('Treatment-Type', 'Admission');
    }

    final response = await query;

    List<Map<String, dynamic>> result = [];

    for (var institution in response) {
      if (institution['Health-Institution-Name'] != null) {
        final fileName = "${institution['Health-Institution-Name']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Health-Institution/$fileName");

        institution['Health-Institution-Image-Url'] = imageUrl;
        result.add(institution);
      }
    }

    // Filter results based on search query
    if (_searchQuery.isNotEmpty) {
      result = result.where((institution) {
        final name =
            institution['Health-Institution-Name']?.toString().toLowerCase() ??
                '';
        return name.contains(_searchQuery);
      }).toList();
    }

    // Sort the result list alphabetically by institution name
    result.sort((a, b) => (a['Health-Institution-Name'] as String)
        .compareTo(b['Health-Institution-Name'] as String));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildSearchBarWithFilter(),
            const SizedBox(height: 30),
            _buildCategories(),
            const SizedBox(height: 30),
            Expanded(
              child:
                  _buildCurrentCategoryList(), // Dynamic content based on category
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryButton(
              LucideIcons.hospital, "All", 0, const Color(0xff5B50A0)),
          _buildCategoryButton(
              LucideIcons.stethoscope, "Outpatient", 1, Colors.green),
          _buildCategoryButton(LucideIcons.bed, "Admission", 2, Colors.red),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
      IconData icon, String label, int categoryIndex, Color color) {
    final bool isSelected = _currentCategoryIndex == categoryIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentCategoryIndex = categoryIndex; // Change category on click
        });
      },
      child: Column(
        children: [
          Icon(icon, color: color, size: 30), // Updated icon without background
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: isSelected ? 40 : 0,
            color: isSelected ? color : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarWithFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search hospitals, clinics...',
          prefixIcon: Icon(Icons.search, color: _primaryColor),
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

  Widget _buildCurrentCategoryList() {
    _selectedtreatmentType = _currentCategoryIndex == 0
        ? 'All'
        : _currentCategoryIndex == 1
            ? 'Outpatient'
            : 'Admission';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: _buildHealthInstitutionsList(),
    );
  }

  Widget _buildHealthInstitutionsList() {
    return FutureBuilder(
        future: _checkInternetConnection(),
        builder: (context, connectionSnapshot) {
          if (connectionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (connectionSnapshot.error is SocketException) {
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
            future: _getHealthInstitutionData(),
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

              final healthInst = snapshot.data ?? [];

              if (healthInst.isEmpty) {
                return const Center(
                    child: Text('No data available. Please check back later'));
              }

              return ListView.builder(
                itemCount: healthInst.length,
                itemBuilder: (context, index) => CardDesign1(
                  goto: () {
                    final id = healthInst[index]['Health-Institution-ID'];
                    GoRouter.of(context).push('/Health-Institution/$id');
                  },
                  image:
                      healthInst[index]['Health-Institution-Image-Url'] ?? '',
                  title: healthInst[index]['Health-Institution-Name'] ??
                      'Unknown Name',
                  subtitle: healthInst[index]['Health-Institution-Type'] ?? '',
                  location:
                      healthInst[index]['Health-Institution-Address'] ?? '',
                ),
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
