import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../BarrelFileScreen.dart';
import 'HealthInstitutionDetails/AffiliatedProfessional.dart';

class MoreInfoInstitutionScreen extends StatefulWidget {
  final String id;

  const MoreInfoInstitutionScreen({super.key, required this.id});

  @override
  State<MoreInfoInstitutionScreen> createState() =>
      _MoreInfoInstitutionScreenState();
}

class _MoreInfoInstitutionScreenState extends State<MoreInfoInstitutionScreen> {
  late Future<Map<String, dynamic>> _future;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
  }

  // Fetch institution details
  Future<Map<String, dynamic>> _fetchInstitutionDetails() async {
    // Get the institution details
    final response = await Supabase.instance.client
        .from('Health-Institution')
        .select()
        .eq('Health-Institution-ID', widget.id)
        .single();

    // Get the services of the insitution
    final services = await Supabase.instance.client
        .from('Health-Institution-Service')
        .select()
        .eq('Health-Institution-ID', widget.id);

    // Get the acredited insurance of the insitution
    final acreditedInsurance = await Supabase.instance.client
        .from('healthinstitutionacreditedinsurance')
        .select()
        .eq('healthinstitutionid', widget.id);

    // Get the image url of the insitution
    final fileName = "${response['Health-Institution-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");

    // Return the institution details
    response['Health-Institution-Image-Url'] = imageUrl;
    response['Health-Institution-Services'] = services;
    response['Health-Institution-Acredited-Insurance'] = acreditedInsurance;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
                _buildBackgroundImage(data['Health-Institution-Image-Url']),
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
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
          (data['Health-Institution-Services'] as List).isNotEmpty
              ? _buildServicesOffers(
                  (data['Health-Institution-Services'] as List)
                      .map((service) =>
                          service['Health-Institution-Service-Name'] as String)
                      .toList(),
                )
              : const SizedBox(),
          (data['Health-Institution-Acredited-Insurance'] as List).isNotEmpty
              ? _buildAccreditedInsurance(
                  (data['Health-Institution-Acredited-Insurance'] as List)
                      .map((service) =>
                          service['healthinstitutionacreditedinsurancename']
                              as String)
                      .toList(),
                )
              : const SizedBox(),
          _buildAffiliatedProfessionalsSection(), // Add this line
          _buildContactSection(data),
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
        _buildTitle(data['Health-Institution-Name'] ?? 'Unknown Name'),
        const SizedBox(height: 10),
        _buildSubtitle(data['Health-Institution-Type'] ?? 'Unknown Type'),
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

  Widget _buildAboutSection(Map<String, dynamic> data) {
    return Center(
      child: _buildAboutUsSection(
        data['Health-Institution-Desc'] ?? 'No description available',
      ),
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> data) {
    return _buildMapSection(
      data['Health-Institution-Address'],
      data['Health-Institution-Address-Lat'] ?? 0.0,
      data['Health-Institution-Address-Long'] ?? 0.0,
      data['Health-Institution-Name'],
    );
  }

  Widget _buildContactSection(Map<String, dynamic> data) {
    return Center(
      child: _buildContactUsSection(data['Health-Institution-ContactNumber']),
    );
  }

  Widget _buildReportSection() {
    return Center(child: _buildReportListing());
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
            children: [
              const TextSpan(
                text: 'Open for ',
                style: TextStyle(color: Color(0xff5B50A0)),
              ),
              const TextSpan(
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

  Widget _buildAboutUsSection(String description) {
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
          description,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _buildMapSection(
      String locationAddress, double lat, double long, String institutionName) {
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
          locationAddress,
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
              target: LatLng(lat, long),
              zoom: 18.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId(institutionName),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(lat, long),
              ),
            },
          ),
        ),
      ],
    );
  }

  // Service Section
  Widget _buildServicesOffers(List<String> servicename) {
    return Column(
      children: [
        _buildDividerWithSpacing(),
        _buildSectionWithList(
          title: 'Services & Guidelines',
          items: servicename,
          buttonText: 'Show all Services',
          onButtonPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Servicesoffered(
                      servicename: servicename,
                    )),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Insurance Section
  Widget _buildAccreditedInsurance(List<String> acreditedinsurances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerWithSpacing(),
        _buildSectionTitle('Accredited Insurances'),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: acreditedinsurances.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle card tap
                  _showSnackBar('Clicked on ${acreditedinsurances[index]}');
                },
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff5B50A0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          acreditedinsurances[index],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

// Affiliated Professionals Section
  Widget _buildAffiliatedProfessionalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerWithSpacing(),
        _buildSectionTitle('Affiliated Professionals'),
        const SizedBox(height: 16),
        ListTile(
          title: Text('John Doe'),
          subtitle: Text('Oncologist'),
          trailing: Text('john.doe@example.com'),
        ),
        ListTile(
          title: Text('Jane Smith'),
          subtitle: Text('Oncologist'),
          trailing: Text('jane.smith@example.com'),
        ),
        const SizedBox(height: 25),
        _buildShowAllButton(
          'Show all Professionals',
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AffiliatedProfessional(),
            ),
          ),
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
      ],
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
  Widget _buildContactUsSection(String contactNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerWithSpacing(),
        _buildSectionTitle('Contact Us'),
        const SizedBox(height: 16),
        _buildContactInfo(contactNumber),
      ],
    );
  }

  // Report Section
  Widget _buildReportListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerWithSpacing(),
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
}
