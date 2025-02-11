import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'OncologistDetailScreen.dart';

class OncologistsScreens extends StatefulWidget {
  const OncologistsScreens({super.key});

  @override
  State<OncologistsScreens> createState() => _OncologistsScreensState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _OncologistsScreensState extends State<OncologistsScreens> {
  final TextEditingController _searchController = TextEditingController();
  String _searchInput = '';
  int _currentCategoryIndex =
      0; // Track current category (0: All, 1: Specialists)
  final String _selectedFilter = 'All'; // Track selected filter

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

  Future<List<Map<String, dynamic>>> _fetchDoctors(String type) async {
    try {
      // Build the query
      var query = Supabase.instance.client.from('Doctor').select();

      if (type != "All") {
        query = query.eq('Specialization', type);
      }

      if (_searchInput != null && _searchInput.isNotEmpty) {
        query = query.ilike("Doctor-Firstname", "%$_searchInput%");
      }

      // Execute the query
      final response = await query;

      // Check if the response contains an error
      if (response == null) {
        throw Exception("Error fetching doctors: Response is null");
      }

      debugPrint("Raw Response: $response"); // Debugging step

      return response;
    } catch (e) {
      debugPrint("Fetch Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildSearchField(),
          const SizedBox(height: 30),
          _buildCategories(),
          const SizedBox(height: 30),
          Expanded(
            child: _buildCurrentCategoryList(),
          ),
        ],
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
              Icon(Icons.search, color: OncologistsScreens._primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: OncologistsScreens._primaryColor),
          ),
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
          _buildCategoryButton(Icons.person, "All", 0, Colors.red),
          _buildCategoryButton(
              Icons.local_hospital, "Specialists", 1, Colors.blue),
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

  Widget _buildCurrentCategoryList() {
    if (_currentCategoryIndex == 0) {
      return _buildDoctorSection("All");
    } else {
      return _buildDoctorSection("Specialists");
    }
  }

  Widget _buildDoctorSection(String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDoctors(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final doctors = snapshot.data ?? [];
        if (doctors.isEmpty) {
          return const Center(child: Text('No doctors found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildDoctorCard(doctors[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OncologistDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.white70, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['Specialization'],
                    style: GoogleFonts.poppins(
                      color: OncologistsScreens._primaryColor,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: OncologistsScreens._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctor['Doctor-Email'],
                    style: GoogleFonts.poppins(
                      color: OncologistsScreens._primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
