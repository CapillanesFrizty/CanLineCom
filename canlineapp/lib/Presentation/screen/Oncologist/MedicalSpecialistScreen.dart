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

  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    var query = Supabase.instance.client
        .from('Doctor')
        .select('*, Health-Institution!inner(Health-Institution-Name)');

    if (_selectedCategory != "All") {
      query = query.eq('Specialization', _selectedCategory);
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
              goto: () => context.push('/Medical-Specialists/${doctor['id']}'),
              image: doctor['Doctor-Image-Url'] ?? "",
              title:
                  '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
              subtitle: doctor['Specialization'] ?? 'Unknown Specialization',
              location: doctor['Health-Institution']
                      ['Health-Institution-Name'] ??
                  'No hospital information',
              address: doctor['Address'] ?? 'No address available',
            );
          },
        );
      },
    );
  }

  // Update the filter bottom sheet UI
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
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: specialists.map((specialization) {
                                    final isSelected =
                                        _selectedCategory == specialization;
                                    return FilterChip(
                                      selected: isSelected,
                                      label: Text(specialization),
                                      labelStyle: GoogleFonts.poppins(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                      selectedColor: MedicalSpecialistScreens
                                          ._primaryColor,
                                      backgroundColor: Colors.grey[100],
                                      checkmarkColor: Colors.white,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedCategory = specialization;
                                        });
                                        this.setState(() {});
                                      },
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                MedicalSpecialistScreens._primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
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
                );
              },
            );
          },
        );
      },
    );
  }

  // Add this helper method for sort chips
  // Widget _buildSortChip(String label) {
  //   return FilterChip(
  //     label: Text(label),
  //     labelStyle: GoogleFonts.poppins(
  //       color: Colors.grey[800],
  //       fontSize: 14,
  //     ),
  //     backgroundColor: Colors.grey[100],
  //     onSelected: (selected) {
  //       // Implement sorting logic
  //     },
  //   );
  // }
}
