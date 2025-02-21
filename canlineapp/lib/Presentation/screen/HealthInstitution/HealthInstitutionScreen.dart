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
  final String _searchQuery = '';
  int _currentCategoryIndex =
      0; // Track current category (0: Hospitals, 1: Clinics, 2: Brgy. HS)
  String _selectedFilter = 'All'; // Track selected filter

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  // Get the health institutions data
  Future<List<Map<String, dynamic>>> _getHealthInstitutionData() async {
    var query = Supabase.instance.client.from('Health-Institution').select();

    if (_selectedFilter != 'All') {
      query = query.eq('Health-Institution-Type', _selectedFilter);
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
        result.add(institution); // Add the institution to the result list
      }
    }

    return result; // Return all institutions with image URLs
  }

  // Get the clinics data
  Future<List<Map<String, dynamic>>> _getClinics() async {
    final responses =
        await Supabase.instance.client.from('Clinic-External').select();

    List<Map<String, dynamic>> result = [];

    for (var clinics in responses) {
      if (clinics['Clinic-Name'] != null) {
        final fileName = "${clinics['Clinic-Name']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Clinic-External/$fileName");

        clinics['Clinic-Image-Url'] = imageUrl;
        result.add(clinics); // Add the institution to the result list
      }
    }

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryButton(
              LucideIcons.hospital, "Hospitals", 0, Colors.red),
          _buildCategoryButton(
              LucideIcons.squareActivity, "Clinics", 1, Colors.blue),
          _buildCategoryButton(
              LucideIcons.housePlus, "Brgy. HS", 2, Colors.orange),
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

  void _applyFilters() {
    setState(() {});
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
                  Text('Institution Type',
                      style: TextStyle(color: _primaryColor)),
                  ToggleButtons(
                    isSelected: [
                      _selectedFilter == 'All',
                      _selectedFilter == 'Private Hospital',
                      _selectedFilter == 'Government Hospital'
                    ],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) _selectedFilter = 'All';
                        if (index == 1) _selectedFilter = 'Private Hospital';
                        if (index == 2) _selectedFilter = 'Government Hospital';
                      });
                    },
                    selectedColor: Colors.white,
                    color: Colors.grey,
                    fillColor: _primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('All')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Private')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Government')),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor),
                      onPressed: () {
                        _applyFilters();
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

  Widget _buildCurrentCategoryList() {
    if (_currentCategoryIndex == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: _buildHealthInstitutionsList(),
      );
    } else if (_currentCategoryIndex == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildClinicList()),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildBrgyHealthStationsList()),
        ],
      );
    }
  }

  Widget _buildHealthInstitutionsList() {
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

        final healthInst = snapshot.data ?? [];

        if (healthInst.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return ListView.builder(
          itemCount: healthInst.length,
          itemBuilder: (context, index) => CardDesign1(
            goto: () {
              final id = healthInst[index]['Health-Institution-ID'];
              context.go('/Health-Institution/$id');
            },
            image: healthInst[index]['Health-Institution-Image-Url'] ?? '',
            title:
                healthInst[index]['Health-Institution-Name'] ?? 'Unknown Name',
            subtitle: healthInst[index]['Health-Institution-Type'] ?? '',
            location: healthInst[index]['Health-Institution-Address'] ?? '',
          ),
        );
      },
    );
  }

  Widget _buildBrgyHealthStationsList() {
    final _futureBrgyHealthStations =
        Supabase.instance.client.from('Brgy-Health-Stations').select();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureBrgyHealthStations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text(
                    textAlign: TextAlign.center,
                    'Sorry for the inconvenience but this Page is Under Construction\n\nPlease check back soon.'));
          }

          final healthStations = snapshot.data ?? [];

          if (healthStations.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: healthStations.length,
            itemBuilder: (context, index) => CardDesign1(
              goto: () {
                final id = healthStations[index]['Health-Institution-ID'];
                context.go('/Health-Institution/$id');
              },
              image:
                  healthStations[index]['Health-Institution-Image-Url'] ?? '',
              title: healthStations[index]['Health-Institution-Name'] ??
                  'Unknown Name',
              subtitle: healthStations[index]['Health-Institution-Type'] ?? '',
            ),
          );
        },
      ),
    );
  }

  Widget _buildClinicList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getClinics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final clinics = snapshot.data ?? [];

          if (clinics.isEmpty) {
            return const Center(child: Text('No clinics available'));
          }

          return ListView.builder(
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final clinicData = clinics[index];
              return CardDesign1(
                goto: () {
                  final clinicId = clinicData['Clinic-ID'];
                  context.go('/Health-Institution/clinic/$clinicId');
                },
                image: clinicData['Clinic-Image-Url'] ?? '',
                title: clinicData['Clinic-Name'] ?? 'Unknown Clinic',
                subtitle: clinicData['Clinic-Type'] ?? 'Unknown Type',
                location: clinicData['Clinic-External-Address'] ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
