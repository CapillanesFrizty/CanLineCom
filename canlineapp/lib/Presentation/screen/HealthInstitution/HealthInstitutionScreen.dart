import 'package:canerline_app/Layouts/Scaffold/ScaffoldLayout.dart';
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

  final _futurepublic = Supabase.instance.client
      .from('Health-Institution')
      .select()
      .eq("Health-Institution-Type", "Government Hospital");

  final _futureprivate = Supabase.instance.client
      .from('Health-Institution')
      .select()
      .eq("Health-Institution-Type", "Private Hospital");

  final _futureclinics =
      Supabase.instance.client.from('Clinic-External').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Health Institution",
          style: GoogleFonts.poppins(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: _primaryColor,
          ),
        ),
        leading: BackButton(
          color: _primaryColor,
          onPressed: () =>
              GoRouter.of(context).go("/HomeScreen/${widget.userid}"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 30),
          // _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategories(),
          const SizedBox(height: 20),
          Expanded(
            child:
                _buildCurrentCategoryGrid(), // Dynamic content based on category
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //     child: TextField(
  //       controller: _searchController,
  //       onChanged: (query) {
  //         setState(() {
  //           _searchQuery = query;
  //         });
  //       },
  //       decoration: InputDecoration(
  //         hintText: 'Search',
  //         prefixIcon: const Icon(Icons.search, color: _primaryColor),
  //         suffixIcon: const Icon(Icons.filter_list, color: _primaryColor),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: _primaryColor),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: _primaryColor),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: _primaryColor),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryButton(
              LucideIcons.ambulance, "Hospitals", 0, Colors.red),
          _buildCategoryButton(LucideIcons.hospital, "Clinics", 1, Colors.blue),
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

  Widget _buildCurrentCategoryGrid() {
    if (_currentCategoryIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Text(
              "Public Hospitals",
              style: TextStyle(
                fontFamily: 'Poppins', // Replace with your font
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: _primaryColor, // Adjust to your theme
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildPublicHealthInstitutionsGrid(),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Private Hospitals",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: _primaryColor,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildPrivateHealthInstitutionsGrid(),
          )),
        ],
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
          Expanded(child: _buildClinicGrid()),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   child: Text(
          //     "Barangay Health Stations",
          //     style: TextStyle(
          //       fontFamily: 'Poppins',
          //       fontWeight: FontWeight.w600,
          //       fontSize: 18,
          //       color: Colors.blueAccent,
          //     ),
          //   ),
          // ),
          Expanded(child: _buildBrgyHealthStationsGrid()),
        ],
      );
    }
  }

  Widget _buildBrgyHealthStationsGrid() {
    // Implement the grid for Brgy. Health Stations
    // Assuming you have a future for Brgy. Health Stations similar to _futurepublic and _futureprivate
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
                    'Sorry for the inconvinience but this Page is Under Construction\n\nPlease check back soon.'));
          }

          final healthStations = snapshot.data ?? [];

          if (healthStations.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1 / 1.2,
            ),
            itemCount: healthStations.length,
            itemBuilder: (context, index) => _HealthInstitutionCard(
              healthInstData: healthStations[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPublicHealthInstitutionsGrid() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futurepublic,
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

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1 / 1.2,
          ),
          itemCount: healthInst.length,
          itemBuilder: (context, index) => _HealthInstitutionCard(
            healthInstData: healthInst[index],
          ),
        );
      },
    );
  }

  Widget _buildPrivateHealthInstitutionsGrid() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureprivate,
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

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1 / 1.2,
          ),
          itemCount: healthInst.length,
          itemBuilder: (context, index) => _HealthInstitutionCard(
            healthInstData: healthInst[index],
          ),
        );
      },
    );
  }

  Widget _buildClinicGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureclinics,
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

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1 / 1.2,
            ),
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final clinicData = clinics[index];
              return _buildClinicCard(clinicData);
            },
          );
        },
      ),
    );
  }

  Widget _buildClinicCard(Map<String, dynamic> clinicData) {
    return FutureBuilder<String>(
      future: _getClinicImageUrl(clinicData),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final clinicId = clinicData['Clinic-ID'];
            context.go('/Health-Institution/clinic/$clinicId');
          },
          image: imageUrl,
          title: clinicData['Clinic-Name'] ?? 'Unknown Clinic',
          subtitle: clinicData['Clinic-Type'] ?? 'Unknown Type',
        );
      },
    );
  }

  Future<String> _getClinicImageUrl(Map<String, dynamic> clinicData) async {
    final fileName = "${clinicData['Clinic-Name']}.png";
    return Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");
  }
}

class _HealthInstitutionCard extends StatelessWidget {
  final Map<String, dynamic> healthInstData;

  const _HealthInstitutionCard({required this.healthInstData});

  Future<String> _getImageUrl() async {
    final fileName = "${healthInstData['Health-Institution-Name']}.png";
    return Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final id = healthInstData['Health-Institution-ID'];
            context.go('/Health-Institution/$id');
          },
          image: imageUrl,
          title: healthInstData['Health-Institution-Name'] ?? 'Unknown Name',
          subtitle: healthInstData['Health-Institution-Type'] ?? '',
        );
      },
    );
  }
}
