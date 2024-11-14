import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Financialdetails extends StatefulWidget {
  final String id;
  const Financialdetails({super.key, required this.id});

  @override
  State<Financialdetails> createState() => _FinancialdetailsState();
}

class _FinancialdetailsState extends State<Financialdetails> {
  late Future<Map<String, dynamic>> _future;
  late Future<List<Map<String, dynamic>>> _futureInstitutionBenefits;
  late Future<Map<String, dynamic>> _futureMoreBenefits;

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

  Future<PostgrestList> _fetchBenefitsDetails(int Bid) async {
    final response = await Supabase.instance.client
        .from('Benefit-Details-Financial-Institution')
        .select('Benefit_name,Benefit_desccription')
        .eq('Financial_Benefit', Bid);
    return response.toList();
  }

  Future<PostgrestList> _fetchRequirements() async {
    final response = await Supabase.instance.client
        .from('Financial-Institution-Requirement')
        .select()
        .eq('Fiancial-Institution-ID', widget.id);

    debugPrint('RESPONSE: $response');

    return response;
  }

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
    _futureInstitutionBenefits = _fetchInstitutionBenefits();
    _fetchRequirements();
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
                ),
                const SizedBox(height: 50),

                // !! Uncomment the code below to display the map
                // TODO: Add the map to the screen
                // Expanded(
                //   child:
                //       // The Map needs a API Key to work
                //       Container(width: 100, height: 100, child: _MapBuilder()),
                // ),
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
      color: Colors.black,
    );
  }

  Widget _buildDetailsSection(
      String name, String description, String hospitalType) {
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
          _buildLocationSection(),
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
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(fontSize: 18, color: Colors.grey),
    );
  }

  Widget _buildAboutUsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOpeningHoursSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Opening Hours',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Mon - Fri: 8:00 AM - 5:00 PM',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        Text('Sat: 8:00 AM - 12:00 AM',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Where are we?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'Barangay Bolton Extension, Poblacion District, Davao City, Davao del Sur',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          color: Colors.grey[300], // Placeholder for map
          child: const Center(child: Text('Map Placeholder')),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return FutureBuilder(
      future: _futureInstitutionBenefits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No facilities available.'));
        }

        final Benefitsdata = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Benefits',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // ! LIST OF EXPANSION PANEL
            ExpansionPanelList(
              children: [
                // ! A instance of Accordion/Expansion
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.medical_services,
                            color: Colors.white, size: 35),
                      ),
                      title: Text(
                        Benefitsdata[0]['Financial-Institution-Benefits-Name']
                            as String,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(Benefitsdata[0]
                            ['Financial-Institution-Benefits-Desc']),
                        SizedBox(height: 24),
                        FutureBuilder<List>(
                            future: _fetchBenefitsDetails(Benefitsdata[0]
                                ['Financial-Institution-Benefits-ID'] as int),
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

                              debugPrint(
                                  'Benefits Details: $BenefitsDetailsdata');

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: BenefitsDetailsdata.map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e['Benefit_name'] ?? 'No name',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(e['Benefit_desccription'] ??
                                          'No name'),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ).toList(),
                              );
                            }),
                      ],
                    ),
                  ),
                  isExpanded: true,
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildRequirementsSection() {
    return FutureBuilder(
      future: _fetchRequirements(),
      builder: (context, snapshot) {
        return Text(snapshot.data.toString());
      },
    );
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // Widget _MapBuilder() {
  //   return GoogleMap(
  //     onMapCreated: _onMapCreated,
  //     initialCameraPosition: CameraPosition(
  //       target: _center, // Coordinates for the physical address
  //       zoom: 15.0, // Adjust the zoom level
  //     ),
  //     markers: {
  //       Marker(
  //         markerId: MarkerId('Health-Institution'),
  //         position: _center,
  //         infoWindow: const InfoWindow(title: 'Health Institution'),
  //       ),
  //     },
  //   );
  // }
}
