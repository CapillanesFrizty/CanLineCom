import 'package:cancerline_companion/Presentation/screen/HealthInstitution/ClinicInstitutionDetails/ClinicAccreditedInsurance.dart';
import 'package:cancerline_companion/Presentation/screen/HealthInstitution/ClinicInstitutionDetails/ClinicServicesOffered.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Centralized color definitions
class AppColors {
  static const Color primary = Color(0xff5B50A0);
  static const Color secondary = Colors.green;
  static const Color divider = Colors.grey;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color background = Colors.white;
}

class MoreinfoClinicsscreen extends StatefulWidget {
  final String id;
  const MoreinfoClinicsscreen({super.key, required this.id});

  @override
  State<MoreinfoClinicsscreen> createState() => _MoreinfoClinicsscreenState();
}

class _MoreinfoClinicsscreenState extends State<MoreinfoClinicsscreen> {
  late Future<Map<String, dynamic>> _future;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _future = _fetchClinicDetails();
  }

  Future<Map<String, dynamic>> _fetchClinicDetails() async {
    final response = await Supabase.instance.client
        .from('Clinic-External')
        .select('*')
        .eq('Clinic-ID', widget.id)
        .single();

    final fileName = "${response['Clinic-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");

    debugPrint('LATLONG: ${response['Clinic-Address-lat']},'
        '${response['Clinic-Address-long']}');

    response['Clinic-Image-Url'] = imageUrl;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => context.go('/Health-Institution'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                _buildBackgroundImage(data['Clinic-Image-Url']),
                _buildDetailsSection(data),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : const Center(child: Text('Image not available')),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        color: const Color(0xff5B50A0),
      ),
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(data),
          _buildDividerWithSpacing(),
          _buildSchedule(),
          _buildDividerWithSpacing(),
          _buildAboutSection(data),
          _buildDividerWithSpacing(),
          _buildLocationSection(data),
          _buildDividerWithSpacing(),
          _buildServicesSection(),
          _buildDividerWithSpacing(),
          _buildInsuranceSection(),
          _buildDividerWithSpacing(),
          _buildContactSection(data),
          _buildDividerWithSpacing(),
          _buildReportSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTitle(data['Clinic-Name'] ?? 'Unknown Name'),
        const SizedBox(height: 10),
        _buildSubtitle(data['Clinic-Type'] ?? 'Unknown Type'),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDividerWithSpacing() {
    return Column(
      children: const [
        Divider(color: Colors.black),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xff5B50A0),
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 15),
            children: const [
              TextSpan(
                text: 'Open for ',
                style: TextStyle(color: Color(0xff5B50A0)),
              ),
              TextSpan(
                text: '24Hours',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['Clinic-Description'] ?? 'No description available',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _buildLocationSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Where are we?',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xff5B50A0),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data['Clinic-External-Address'] ?? '',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          width: 500,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            liteModeEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                data['Clinic-Address-lat'] ?? 0.0,
                data['Clinic-Address-long'] ?? 0.0,
              ),
              zoom: 18.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId(data['Clinic-Name']),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(
                  data['Clinic-Address-lat'] ?? 0.0,
                  data['Clinic-Address-long'] ?? 0.0,
                ),
              ),
            },
          ),
        ),
      ],
    );
  }

  // Service Section
  Widget _buildServicesSection() {
    return _buildSectionWithList(
      title: 'Services Offered',
      items: const [
        'Therapeutics',
        'Diagnostics (Including Children)',
        'Radiotherapy (Including Children)',
        'Brachytherapy',
        'Outpatient chemotherapy',
      ],
      buttonText: 'Show all Services',
      onButtonPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Clinicservicesoffered()),
      ),
    );
  }

  // Insurance Section
  Widget _buildInsuranceSection() {
    return _buildSectionWithList(
      title: 'Accredited Insurances',
      items: const ['Maxicare', 'Intellicare', 'PhilHealth'],
      buttonText: 'Show all insurances',
      onButtonPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const Clinicaccreditedinsurance()),
      ),
    );
  }

  // Generic list builder with bullet points
  Widget _buildSectionWithList({
    required String title,
    required List<String> items,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items.map((item) => _buildBulletItem(item)),
              const SizedBox(height: 25),
              _buildShowAllButton(buttonText, onButtonPressed),
            ],
          ),
        ),
      ],
    );
  }

  // Contact Section
  Widget _buildContactSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contact Us'),
        const SizedBox(height: 16),
        _buildContactInfo(
            data['Clinic-ContactNumber'] ?? 'No contact available'),
      ],
    );
  }

  // Report Section
  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _showSnackBar('This feature is not available right now'),
          child: _buildReportHeader(),
        ),
        const SizedBox(height: 10),
        Text(
          'if bugs and inaccuracy occurred',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: const Color(0xffFFA133),
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xff5B50A0),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowAllButton(String text, VoidCallback onPressed) {
    return Center(
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff5B50A0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String contactNumber) {
    return Row(
      children: [
        const Icon(Icons.phone_outlined, color: Colors.black, size: 25),
        const SizedBox(width: 10),
        Text(
          contactNumber,
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildReportHeader() {
    return Row(
      children: [
        const Icon(Icons.flag_outlined, color: Colors.black, size: 25),
        const SizedBox(width: 10),
        Text(
          'Report Listing',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
