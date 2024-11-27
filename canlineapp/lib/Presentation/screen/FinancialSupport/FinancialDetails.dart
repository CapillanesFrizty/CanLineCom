import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FinancialDetailsScreen extends StatefulWidget {
  const FinancialDetailsScreen({super.key});

  @override
  State<FinancialDetailsScreen> createState() => _FinancialDetailsScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
}

class _FinancialDetailsScreenState extends State<FinancialDetailsScreen> {
  late GoogleMapController mapController;
  final List<bool> _isExpandedBenefits = [false];
  final List<bool> _isExpandedRequirements = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Financial Details'),
            const SizedBox(height: 16),
            _buildSectionTitle('Description'),
            const SizedBox(height: 8),
            _buildDescription(
                'This is the description of the financial details.'),
            const SizedBox(height: 16),
            _buildSectionTitle('Details'),
            const SizedBox(height: 8),
            _buildDescription(
                'Here are more details about the financial information.'),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:
            Icon(Icons.arrow_back, color: FinancialDetailsScreen._primaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: FinancialDetailsScreen._primaryColor,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: FinancialDetailsScreen._primaryColor,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: FinancialDetailsScreen._primaryColor,
      ),
    );
  }
}

class Financialdetails extends StatefulWidget {
  final String id;
  const Financialdetails({super.key, required this.id});

  @override
  State<Financialdetails> createState() => _FinancialdetailsState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _FinancialdetailsState extends State<Financialdetails> {
  late Future<Map<String, dynamic>> _future;
  late Future<List<Map<String, dynamic>>> _futureInstitutionBenefits;
  late GoogleMapController mapController;
  final List<bool> _isBenefitsExpanded = [false];
  final List<bool> _isRequirementsExpanded = [false];

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
    _futureInstitutionBenefits = _fetchInstitutionBenefits();
  }

  Future<Map<String, dynamic>> _fetchInstitutionDetails() async {
    final response = await Supabase.instance.client
        .from('Financial-Institution')
        .select()
        .eq('Financial-Institution-ID', widget.id)
        .single();

    // Generate image URL
    final fileName = "${response['Financial-Institution-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Financial-Institution/$fileName");

    response['Financial-Institution-Image-Url'] = imageUrl;

    return response;
  }

  Future<List<Map<String, dynamic>>> _fetchInstitutionBenefits() async {
    final response = await Supabase.instance.client
        .from('Financial-Institution-Benefit')
        .select()
        .eq('Financial-Institution-ID', widget.id);

    return response;
  }

  Future<List<Map<String, dynamic>>> _fetchBenefitsDetails(int Bid) async {
    final response = await Supabase.instance.client
        .from('Benefit-Details-Financial-Institution')
        .select('Benefit_name,Benefit_desccription')
        .eq('Financial_Benefit', Bid);
    return response.toList();
  }

  Future<List<Map<String, dynamic>>> _fetchRequirements() async {
    final response = await Supabase.instance.client
        .from('Financial-Institution-Requirement')
        .select()
        .eq('Fiancial-Institution-ID', widget.id);

    debugPrint('RESPONSE: $response');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _buildImageSection(data['Financial-Institution-Image-Url']),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  data['Financial-Institution-Name'] ?? 'Unknown Name',
                  data['Financial-Institution-Desc'] ??
                      'No description available',
                  data['Financial-Institution-Type'] ?? 'Unknown Type',
                  data['Financial-Institution-Address-Lat'] ?? 0.0,
                  data['Financial-Institution-Address-Long'] ?? 0.0,
                  data['Financial-Institution-Address'],
                  data['Financial-Institution-Name'],
                ),
                const SizedBox(height: 50),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Stack(
      children: [
        _buildBackgroundImage(imageUrl),
        _buildTopIcons(),
      ],
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: ClipRRect(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
              )
            : const Center(
                child: Text('Image not available'),
              ),
      ),
    );
  }

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
              Icons.arrow_back, () => context.go('/Financial-Institution')),
          Row(
            children: [
              _buildIconButton(
                  Icons.share, () {}), // Placeholder for share action
              _buildIconButton(Icons.favorite_outline,
                  () {}), // Placeholder for favorite action
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 30,
      color: Financialdetails._primaryColor,
    );
  }

  Widget _buildDetailsSection(
      String name,
      String description,
      String hospitalType,
      double lat,
      double long,
      String locationAddress,
      String InstitutionMarkerID) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(name),
          _buildSubtitle(hospitalType),
          const SizedBox(height: 16),
          _buildOpeningHoursSection(),
          const SizedBox(height: 16),
          _buildAboutUsSection(description),
          const SizedBox(height: 16),
          _buildMapSection(locationAddress, lat, long, InstitutionMarkerID),
          const SizedBox(height: 16),
          _buildBenefitsSection(),
          const SizedBox(height: 16),
          _buildRequirementsSection()
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Financialdetails._primaryColor,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.grey,
      ),
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
            fontWeight: FontWeight.bold,
            color: Financialdetails._primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Financialdetails._primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOpeningHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Financialdetails._primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mon - Fri: 8:00 AM - 5:00 PM',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Financialdetails._primaryColor,
          ),
        ),
        Text(
          'Sat: 8:00 AM - 12:00 AM',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Financialdetails._primaryColor,
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _buildMapSection(String locationAddress, double lat, double long,
      String InstitutionMarkerID) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Where are we?',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          locationAddress,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
                markerId: MarkerId(InstitutionMarkerID),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(lat, long),
              ),
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _futureInstitutionBenefits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No benefits available.'));
          }

          final Benefitsdata = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Benefits',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Financialdetails._primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isBenefitsExpanded[index] =
                        !_isBenefitsExpanded[index]; // Toggle the state
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.medical_services,
                              color: Colors.white, size: 30),
                        ),
                        title: Text(
                          'Benefits',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            color: Financialdetails._primaryColor,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          Text(
                            Benefitsdata[0]
                                ['Financial-Institution-Benefits-Desc'],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Financialdetails._primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FutureBuilder<List>(
                            future: _fetchBenefitsDetails(
                              Benefitsdata[0]
                                  ['Financial-Institution-Benefits-ID'] as int,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No more details available.'));
                              }

                              final BenefitsDetailsdata = snapshot.data!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: BenefitsDetailsdata.map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e['Benefit_name'] ?? 'No name',
                                        style: GoogleFonts.poppins(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Financialdetails._primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        e['Benefit_desccription'] ?? 'No name',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Financialdetails._primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    isExpanded: _isBenefitsExpanded[0],
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requirements',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Financialdetails._primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isRequirementsExpanded[index] =
                    !_isRequirementsExpanded[index]; // Toggle state
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueAccent,
                      child:
                          Icon(Icons.assignment, color: Colors.white, size: 30),
                    ),
                    title: Text(
                      'Requirements',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        color: Financialdetails._primaryColor,
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _fetchRequirements(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No requirements available.'));
                      }

                      final Requirementsdata = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: Requirementsdata.map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['Financial-Institution-Requirements-Name'] ??
                                    'No name',
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Financialdetails._primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                e['Financial-Institution-Requirements-Desc'] ??
                                    'No description',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Financialdetails._primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ).toList(),
                      );
                    },
                  ),
                ),
                isExpanded: _isRequirementsExpanded[0],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
