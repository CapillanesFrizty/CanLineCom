import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OncologistsScreens extends StatefulWidget {
  const OncologistsScreens({super.key});

  @override
  State<OncologistsScreens> createState() => _OncologistsScreensState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _OncologistsScreensState extends State<OncologistsScreens> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchInput = '';
  String _selectedCategory = 'All'; // Track selected category

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
    // Build the query
    var query = Supabase.instance.client.from('Doctor').select();

    if (_selectedCategory != "All") {
      query = query.eq('Specialization', _selectedCategory);
    }

    if (_searchInput.isNotEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildSearchField(),
          const SizedBox(height: 30),
          Expanded(
            child: _buildDoctorSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Stack(
        children: [
          TextField(
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
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.filter_list,
                  color: OncologistsScreens._primaryColor),
              onPressed: () => _showFilterBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildFilterBottomSheet();
      },
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter',
            style: TextStyle(
              color: OncologistsScreens._primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('All'),
            onTap: () {
              setState(() {
                _selectedCategory = 'All';
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Specialists'),
            onTap: () {
              setState(() {
                _selectedCategory = 'Specialists';
              });
              Navigator.of(context).pop();
            },
          ),
        ],
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
        context.go('/Oncologist/${doctor['id']}');
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
              child:
                  Icon(Icons.person_4_rounded, color: Colors.white70, size: 40),
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
