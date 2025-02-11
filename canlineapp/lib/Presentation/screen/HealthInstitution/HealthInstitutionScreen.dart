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

  final _futureprivate = Supabase.instance.client
      .from('Health-Institution')
      .select()
      .eq("Health-Institution-Type", "Private Hospital");

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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildCategories(),
          const SizedBox(height: 30),
          if (_currentCategoryIndex == 0)
            _buildFilterButton(), // Add filter button only for hospitals
          const SizedBox(height: 10),
          Expanded(
            child:
                _buildCurrentCategoryList(), // Dynamic content based on category
          ),
        ],
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

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter by Type:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton<String>(
            value: _selectedFilter,
            items: <String>['All', 'Private Hospital', 'Government Hospital']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
          ),
        ],
      ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Text(
              "Clinics",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: _primaryColor,
              ),
            ),
          ),
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
          return const Center(child: Text('Error fetching data'));
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
              );
            },
          );
        },
      ),
    );
  }
}
