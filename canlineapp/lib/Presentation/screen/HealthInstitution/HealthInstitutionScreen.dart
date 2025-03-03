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
  final String _searchQuery = '';
  int _currentCategoryIndex =
      0; // Track current category (0: Hospitals, 1: Clinics, 2: Brgy. HS)
  String _selectedFilter = 'All';
  String _selectedSpecialty = 'All';
  bool _is24Hours = false;
  bool _hasEmergencyServices = false;
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
      query = query.eq('Service-Type', 'Outpatient');
    } else if (_currentCategoryIndex == 2) {
      query = query.eq('Service-Type', 'Admission');
    }

    // Apply Specialty filter
    if (_selectedSpecialty != 'All') {
      query = query.eq('Specialty', _selectedSpecialty);
    }

    // Apply 24/7 Service filter
    if (_is24Hours) {
      query = query.eq('Is24Hours', true);
    }

    // Apply Emergency Services filter
    if (_hasEmergencyServices) {
      query = query.eq('HasEmergencyServices', true);
    }

    // Apply Insurance filter
    if (_selectedInsurance.isNotEmpty) {
      query = query.contains('AcceptedInsurance', _selectedInsurance);
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

    // Sort the result list alphabetically by institution name
    result.sort((a, b) => (a['Health-Institution-Name'] as String)
        .compareTo(b['Health-Institution-Name'] as String));

    return result;
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filters',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor)),
                        const SizedBox(height: 20),

                        // Specialty Filter
                        Text('Specialty',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedSpecialty,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: specialties
                              .map((specialty) => DropdownMenuItem(
                                    value: specialty,
                                    child: Text(specialty),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecialty = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Additional Services
                        Text('Additional Services',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor)),
                        CheckboxListTile(
                          title: const Text('24/7 Service'),
                          value: _is24Hours,
                          onChanged: (bool? value) {
                            setState(() {
                              _is24Hours = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Emergency Services'),
                          value: _hasEmergencyServices,
                          onChanged: (bool? value) {
                            setState(() {
                              _hasEmergencyServices = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Insurance Acceptance
                        Text('Accepted Insurance',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor)),
                        ...insuranceProviders.map((insurance) {
                          return CheckboxListTile(
                            title: Text(insurance),
                            value: _selectedInsurance.contains(insurance),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  _selectedInsurance.add(insurance);
                                } else {
                                  _selectedInsurance.remove(insurance);
                                }
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 20),

                        // Apply Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              minimumSize: const Size(200, 45),
                            ),
                            onPressed: () {
                              _applyFilters();
                              Navigator.pop(context);
                            },
                            child: const Text('Apply Filters',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCurrentCategoryList() {
    _selectedFilter = _currentCategoryIndex == 0
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
