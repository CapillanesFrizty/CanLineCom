import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../BarrelFileScreen.dart';
import 'HealthInstitutionDetails/AffiliatedProfessional.dart';

import 'package:readmore/readmore.dart';

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

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
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
        .eq('Health-Institution', widget.id)
        .limit(2);

    // Get the acredited insurance of the insitution
    final acreditedInsurance = await Supabase.instance.client
        .from('healthinstitutionacreditedinsurance')
        .select()
        .eq('healthinstitutionid', widget.id);

    // Get the affiliated Doctors of the insitution (limited to 2)
    final affiliatedDoctors = await Supabase.instance.client
        .from('Doctor')
        .select()
        .eq('Affailated_at', widget.id)
        .limit(2);

    // Get the image url of the insitution
    final fileName = "${response['Health-Institution-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");

    // Get the chemotherapy services of the institution
    // final chemotherapyServices = await Supabase.instance.client
    //     .from('Chemotherapy_Services')
    //     .select()
    //     .eq('Health-Institution', widget.id);

    // Return the institution details
    response['Health-Institution-Image-Url'] = imageUrl;
    response['Health-Institution-Services'] = services;
    response['Health-Institution-Acredited-Insurance'] = acreditedInsurance;
    response['Health-Institution-Affiliated-Doctors'] = affiliatedDoctors;
    // response['Chemotherapy-Services'] = chemotherapyServices;
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
      body: FutureBuilder(
          future: _checkInternetConnection(),
          builder: (context, internetSnapshot) {
            if (internetSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (internetSnapshot.error is SocketException) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xff5B50A0).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          size: 60,
                          color: Color(0xff5B50A0),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Internet Connection',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please check your network connection and try again',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _refreshContent,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5B50A0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return FutureBuilder<Map<String, dynamic>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              size: 60,
                              color: Colors.red[400],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Something went wrong',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[400],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We\'re having trouble loading the data.\nPlease try again later.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ListView(
                    children: [
                      _buildBackgroundImage(
                          data['Health-Institution-Image-Url'] ??
                              Icon(Icons.image)),
                      _buildDetailsSection(data),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.inbox_rounded,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Data Available',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please check back later',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }),
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
          _buildChemotherapySection(),
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

          (data['Health-Institution-Affiliated-Doctors'] as List).isNotEmpty
              ? _buildAffiliatedProfessionalsSection(
                  (data['Health-Institution-Affiliated-Doctors'] as List)
                      .map((doctor) => <String, String>{
                            'name':
                                '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
                            'email': doctor['Doctor-Email'].toString(),
                            'Specialization':
                                doctor['Specialization'].toString(),
                          })
                      .toList())
              : const SizedBox(),
          // Add this line
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
        _buildTitle(data['Health-Institution-Name'] ?? 'Unknown Name'),
        const SizedBox(height: 10),
        _buildSubtitle(data['Health-Institution-Type'] ?? 'Unknown Type'),
      ],
    );
  }

  Widget _buildDividerWithSpacing() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Divider(color: Colors.black),
        SizedBox(height: 20),
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
        ReadMoreText(
          description,
          trimLines: 6,
          colorClickableText: const Color(0xff5B50A0),
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.black,
          ),
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
          title: 'Other Services Offered & Guidelines',
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
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: acreditedinsurances.length,
            itemBuilder: (context, index) {
              return Container(
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 101, 99, 116),
                    width: 2,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 120,
                        color: const Color.fromARGB(255, 17, 16, 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        acreditedinsurances[index],
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
  Widget _buildAffiliatedProfessionalsSection(
      List<Map<String, String>> affiliatedDoctors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerWithSpacing(),
        _buildSectionTitle('Affiliated Professionals'),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: affiliatedDoctors.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(affiliatedDoctors[index]["name"] as String),
              subtitle:
                  Text(affiliatedDoctors[index]["Specialization"] as String),
            );
          },
        ),
        _buildShowAllButton(
          'Show all Professionals',
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AffiliatedProfessional(
                healthInstitutionid: widget.id,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
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
              fontSize: 17,
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

  // Add this method to the _MoreInfoInstitutionScreenState class
  Widget _buildChemotherapySection() {
    // Placeholder data
    final List<String> placeholderServices = [
      'Outpatient Chemotherapy',
      'Inpatient Chemotherapy',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Chemotherapy Services',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff5B50A0),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xff5B50A0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Treatment Options:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: placeholderServices.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Color(0xff5B50A0), size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            placeholderServices[index],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                'The chemotheraphy service will depends on the treatment plan of your doctor.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
