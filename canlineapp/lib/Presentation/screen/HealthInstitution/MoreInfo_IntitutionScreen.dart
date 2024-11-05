import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MoreInfoInstitutionScreen extends StatefulWidget {
  final String id;

  const MoreInfoInstitutionScreen({super.key, required this.id});

  @override
  State<MoreInfoInstitutionScreen> createState() =>
      _MoreInfoInstitutionScreenState();
}

class _MoreInfoInstitutionScreenState extends State<MoreInfoInstitutionScreen> {
  late Future<Map<String, dynamic>> _future;
  static const LatLng _center = LatLng(7.099091, 125.616108);
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
  }

  Future<Map<String, dynamic>> _fetchInstitutionDetails() async {
    final response = await Supabase.instance.client
        .from('Health-Institution')
        .select()
        .eq('Health-Institution-ID', widget.id)
        .single();

    final fileName = "${response['Health-Institution-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");

    response['Health-Institution-Image-Url'] = imageUrl;
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
                _buildImageSection(data['Health-Institution-Image-Url']),
                _buildDetailsSection(
                  name: data['Health-Institution-Name'] ?? 'Unknown Name',
                  description: data['Health-Institution-Desc'] ??
                      'No description available',
                  type: data['Health-Institution-Type'] ?? 'Unknown Type',
                ),
                // TODO: Add map widget if required
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
      height: 300,
      child: ClipRRect(
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : const Center(child: Text('Image not available')),
      ),
    );
  }

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
              Icons.arrow_back, () => context.go('/Health-Insititution')),
          Row(
            children: [
              _buildIconButton(Icons.share, () {}),
              const SizedBox(width: 10.0),
              _buildIconButton(Icons.favorite_outline, () {}),
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
      iconSize: 20,
      color: const Color(0xff5B50A0),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
      ),
    );
  }

  Widget _buildDetailsSection(
      {required String name,
      required String description,
      required String type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(name),
          const SizedBox(height: 16),
          _buildSubtitle(type),
          const SizedBox(height: 16),
          _buildFacilitiesBox(),
          const SizedBox(height: 16),
          _buildAboutUsSection(description),
          const SizedBox(height: 16),
          _buildContactUsSection(),
          const SizedBox(height: 16),
          _buildScheduleSection(),
          const SizedBox(height: 16),
          _buildMapSection(),
          const SizedBox(height: 16),
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
      style: const TextStyle(fontSize: 16, color: Colors.green),
    );
  }

  Widget _buildFacilitiesBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () =>
                context.go('/HealthInstitutionFacilities', extra: 'Facilities'),
            child: _buildClickableInfoColumn('Facilities', '10'),
          ),
          const VerticalDivider(thickness: 5, color: Color(0xff5B50A0)),
          GestureDetector(
            onTap: () => context.go('/HealthInstitutionFacilities',
                extra: 'Accredited Insurance'),
            child: _buildClickableInfoColumn('Accredited Insurance', '5'),
          ),
          const VerticalDivider(),
          GestureDetector(
            onTap: () =>
                context.go('/HealthInstitutionFacilities', extra: 'Doctors'),
            child: _buildClickableInfoColumn('Doctors', '20'),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableInfoColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff5B50A0),
            decoration: TextDecoration.underline, // Underlines the text
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0)),
        ),
      ],
    );
  }

  Widget _buildAboutUsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xff5B50A0)),
        const SizedBox(height: 20),
        const Text(
          'About Us',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0)),
        ),
        const SizedBox(height: 20),
        Text(description, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        const Divider(color: Color(0xff5B50A0)),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Opening Hours',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0)),
        ),
        SizedBox(height: 20),
        Text('Mon - Fri: 8:00am - 6:00pm',
            style: TextStyle(fontSize: 18, color: Color(0xff5B50A0))),
        SizedBox(height: 8),
        Divider(color: Color(0xff5B50A0)),
      ],
    );
  }

  Widget _buildContactUsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0)),
        ),
        Text('09131112421',
            style: TextStyle(fontSize: 18, color: Color(0xff5B50A0))),
        Divider(color: Color(0xff5B50A0)),
      ],
    );
  }

  Widget _buildMapSection() {
    return const Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            'Where are we?',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B50A0),
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _mapBuilder() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('Health-Institution'),
          position: _center,
          infoWindow: InfoWindow(title: 'Health Institution'),
        ),
      },
    );
  }
}
