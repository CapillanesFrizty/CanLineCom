import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:canerline_app/Presentation/widgets/Card/CardDesign1.dart';
import 'package:google_fonts/google_fonts.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  final _clinicFuture =
      Supabase.instance.client.from('Clinic-External').select();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 10),
          _buildSearchField(),
          const SizedBox(height: 20),
          _buildClinicGrid(),
        ],
      ),
    );
  }

  // Build the title widget
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF5B50A0)),
            onPressed: () {
              context.go('/'); // Navigates to the home route instead of popping
            },
          ),
          SizedBox(
              width: 10.0), // Adds some space between the icon and the title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinics',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Color(0xFF5B50A0),
                  ),
                ),
              ),
              Text(
                '(External)',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Color(0xFF5B50A0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffF3EBFF),
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: Color(0xff5B50A0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xffF3EBFF), width: 1.0), // Border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xff5B50A0), width: 1.5), // Border when focused
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Color(0xff5B50A0), fontSize: 14.0),
        ),
      ),
    );
  }

  // Build the grid of clinics using FutureBuilder
  Widget _buildClinicGrid() {
    return FutureBuilder(
      future: _clinicFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        final List<Map<String, dynamic>> clinics = snapshot.data ?? [];

        if (clinics.isEmpty) {
          return const Center(child: Text('No clinics available'));
        }

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              height: 500,
              child: GridView.builder(
                itemCount: clinics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1.2,
                ),
                itemBuilder: (context, index) {
                  final clinicData = clinics[index];
                  return _buildClinicCard(clinicData);
                },
              ),
            ));
      },
    );
  }

  // Build each clinic card with navigation and data handling
  Widget _buildClinicCard(Map<String, dynamic> clinicData) {
    return FutureBuilder(
      future: _getImageUrl(clinicData),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final clinicId = clinicData['Clinic-ID'];
            context.go('/clinic/$clinicId');
          },
          image: imageUrl,
          title: clinicData['Clinic-Name'] ?? 'Unknown Clinic',
          subtitle: clinicData['Clinic-Type'] ?? 'Unknown Type',
        );
      },
    );
  }

  // Get the image URL for a clinic
  Future<String> _getImageUrl(Map<String, dynamic> clinicData) async {
    final fileName = "${clinicData['Clinic-Name']}.png";
    final response = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");
    debugPrint("Fetched image URL: $response");

    return response;
  }
}
