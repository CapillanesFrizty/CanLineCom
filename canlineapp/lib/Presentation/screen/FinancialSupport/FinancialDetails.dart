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

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
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
          _buildAboutUsSection(description),
          const SizedBox(height: 16),
          _buildOpeningHoursSection(),
          const SizedBox(height: 16),
          _buildLocationSection(),
          const SizedBox(height: 16),
          _buildBenefitsSection(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Opening Hours',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Mon - Fri: 8:00 AM - 5:00 PM',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const Text('Sat: 8:00 AM - 12:00 AM',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Benefits',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBenefitCard(
                Icons.local_hospital, 'Outpatient Benefits', Colors.green),
            _buildBenefitCard(Icons.bed, 'Z Benefits', Colors.orange),
            _buildBenefitCard(
                Icons.child_care, 'Inpatient Benefits', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCard(IconData icon, String title, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
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
