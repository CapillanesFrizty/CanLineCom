import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/Card/CardDesign1.dart';

class MedicalSpecialistScreens extends StatefulWidget {
  const MedicalSpecialistScreens({super.key});

  @override
  State<MedicalSpecialistScreens> createState() =>
      _MedicalSpecialistScreensState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _MedicalSpecialistScreensState extends State<MedicalSpecialistScreens> {
  // Constants
  static const double _cardHeight = 200.0;

  // Styles
  final _titleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 30.0,
      color: MedicalSpecialistScreens._primaryColor,
    ),
  );

  final _sectionTitleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: MedicalSpecialistScreens._primaryColor,
    ),
  );

  final TextEditingController _searchController = TextEditingController();
  String _searchInput = '';
  String _selectedCategory = 'All';
  List<String> _selectedSpecializations = [];

  // Update the specializations list
  final List<Map<String, List<String>>> _specializations = [
    {
      'Cancer Care': [
        'All',
        'Medical Oncologist',
        'Surgical Oncologist',
        'Radiation Oncologist',
        'Hematologist',
        'Gynecologic Oncologist',
        'Pediatric Oncologist',
      ],
    },
    {
      'Mental Health': [
        'Psychiatrist',
        'Psycho-Oncologist',
        'Neuropsychiatrist',
        'Pain Management Specialist',
      ],
    },
    {
      'Surgical Specialists': [
        'General Surgeon',
        'Neurosurgeon',
        'Thoracic Surgeon',
        'Reconstructive Surgeon',
      ],
    },
    {
      'Support Specialists': [
        'Radiologist',
        'Pathologist',
        'Nuclear Medicine Specialist',
        'Palliative Care Specialist',
        'Physical Medicine',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() => _searchInput = _searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com'); // Add timeout
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    var query = Supabase.instance.client
        .from('Doctor')
        .select('*, Health-Institution!inner(Health-Institution-Name)');

    if (_selectedSpecializations.isNotEmpty &&
        !_selectedSpecializations.contains('All')) {
      query = query.inFilter('Specialization', _selectedSpecializations);
    }

    if (_searchInput.isNotEmpty) {
      query = query.ilike("Doctor-Firstname", "%$_searchInput%");
    }

    final response = await query;
    List<Map<String, dynamic>> result = [];

    for (var doctor in response) {
      if (doctor['Doctor-Firstname'] != null) {
        result.add(doctor);
      }
    }

    // Sort the result list by Doctor-Firstname
    result.sort((a, b) => (a['Doctor-Firstname'] as String)
        .compareTo(b['Doctor-Firstname'] as String));
    debugPrint('Results: $result.toString()');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildSearchField(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildDoctorSection(),
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

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon:
              Icon(Icons.search, color: MedicalSpecialistScreens._primaryColor),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list,
                color: MedicalSpecialistScreens._primaryColor),
            onPressed: () => _showFilterBottomSheet(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: MedicalSpecialistScreens._primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: MedicalSpecialistScreens._primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: MedicalSpecialistScreens._primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSection() {
    return FutureBuilder(
        future: _checkInternetConnection(),
        builder: (context, networkSnapshot) {
          if (networkSnapshot.data == false) {
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
            future: _fetchDoctors(),
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
                        onPressed: () => setState(() {}),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              final doctors = snapshot.data ?? [];
              if (doctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No doctors found'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return CardDesign1(
                    goto: () =>
                        context.push('/Medical-Specialists/${doctor['id']}'),
                    image: doctor['Doctor-Image-Url'] ?? "",
                    title:
                        '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
                    subtitle:
                        doctor['Specialization'] ?? 'Unknown Specialization',
                    location: doctor['Health-Institution']
                            ['Health-Institution-Name'] ??
                        'No hospital information',
                    address: doctor['Address'] ?? 'No address available',
                  );
                },
              );
            },
          );
        });
  }

  // Replace _showFilterBottomSheet method
  void _showFilterBottomSheet() {
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
                            'Filter Specialists',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MedicalSpecialistScreens._primaryColor,
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
                          itemCount: _specializations.length,
                          itemBuilder: (context, index) {
                            final category = _specializations[index];
                            final title = category.keys.first;
                            final specialists = category.values.first;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        MedicalSpecialistScreens._primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...specialists.map((specialization) {
                                  return CheckboxListTile(
                                    title: Text(specialization),
                                    value: _selectedSpecializations
                                        .contains(specialization),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          if (specialization == 'All') {
                                            _selectedSpecializations.clear();
                                          } else {
                                            _selectedSpecializations
                                                .remove('All');
                                          }
                                          _selectedSpecializations
                                              .add(specialization);
                                        } else {
                                          _selectedSpecializations
                                              .remove(specialization);
                                        }
                                      });
                                    },
                                    activeColor:
                                        MedicalSpecialistScreens._primaryColor,
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
                                  _selectedSpecializations.clear();
                                  _selectedSpecializations.add('All');
                                });
                              },
                              child: const Text('Clear All'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    MedicalSpecialistScreens._primaryColor,
                              ),
                              onPressed: () {
                                this.setState(() {});
                                Navigator.pop(context);
                              },
                              child: const Text('Apply Filters',
                                  style: TextStyle(color: Colors.white)),
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
}
