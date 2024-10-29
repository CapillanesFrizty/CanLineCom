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
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  final _clinicFuture =
      Supabase.instance.client.from('Clinic-External').select();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildSearchField(),
            _buildClinicGrid(),
          ],
        ),
      ),
    );
  }

  // Build the title widget
  Widget _buildTitle() {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      color: _primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinics', style: titleStyle),
          Text('(External)', style: titleStyle),
        ],
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: TextField(
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: _secondaryColor,
            contentPadding: EdgeInsets.zero,
            prefixIcon: const Icon(Icons.search, color: _primaryColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: _secondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: _primaryColor, width: 1.5),
            ),
            hintText: "Search",
            hintStyle: const TextStyle(color: _primaryColor, fontSize: 14.0),
          ),
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

        return SizedBox(
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
        );
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
