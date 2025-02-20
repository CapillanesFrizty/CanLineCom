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
    var query = Supabase.instance.client.from('Doctor').select();

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
        final fileName =
            "${doctor['Doctor-Firstname']}_${doctor['Doctor-Lastname']}.png";
        final imageUrl = Supabase.instance.client.storage
            .from('Assets')
            .getPublicUrl("Doctors/$fileName");

        doctor['Doctor-Image-Url'] = imageUrl;
        result.add(doctor);
      }
    }

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
              goto: () => context.push('/Doctor/${doctor['Doctor-ID']}'),
              image: doctor['Doctor-Image-Url'] ?? '',
              title:
                  '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
              subtitle: doctor['Specialization'] ?? 'Unknown Specialization',
              location: doctor['Hospital'] ?? 'No hospital information',
              address: doctor['Address'] ?? 'No address available',
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet() {
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
                          color: MedicalSpecialistScreens._primaryColor)),
                  SizedBox(height: 16),
                  Text('Specialist Type',
                      style: TextStyle(
                          color: MedicalSpecialistScreens._primaryColor)),
                  ToggleButtons(
                    isSelected: [
                      _selectedCategory == 'All',
                      _selectedCategory == 'Oncologist',
                      _selectedCategory == 'Specialist'
                    ],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) _selectedCategory = 'All';
                        if (index == 1) _selectedCategory = 'Oncologist';
                        if (index == 2) _selectedCategory = 'Specialist';
                      });
                      this.setState(() {});
                    },
                    selectedColor: Colors.white,
                    color: Colors.grey,
                    fillColor: MedicalSpecialistScreens._primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('All'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Oncologist'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Specialist'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MedicalSpecialistScreens._primaryColor,
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
