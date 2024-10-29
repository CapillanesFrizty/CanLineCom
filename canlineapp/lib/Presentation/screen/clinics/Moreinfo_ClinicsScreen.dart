import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MoreinfoClinicsscreen extends StatefulWidget {
  final String id;
  const MoreinfoClinicsscreen({super.key, required this.id});

  @override
  State<MoreinfoClinicsscreen> createState() => _MoreinfoClinicsscreenState();
}

class _MoreinfoClinicsscreenState extends State<MoreinfoClinicsscreen> {
  late Future<Map<String, dynamic>> _clinicDetailsFuture;
  // static const LatLng _defaultLocation = LatLng(7.099091, 125.616108);
  // late GoogleMapController _mapController;

  Future<Map<String, dynamic>> _fetchClinicDetails() async {
    final response = await Supabase.instance.client
        .from('Clinic-External')
        .select()
        .eq('Clinic-ID', widget.id)
        .single();

    // Generate image URL
    final fileName = "${response['Clinic-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");

    response['Clinic-Image-Url'] = imageUrl;

    return response;
  }

  @override
  void initState() {
    super.initState();
    _clinicDetailsFuture = _fetchClinicDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _clinicDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                _buildImageSection(data['Clinic-Image-Url']),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  data['Clinic-Name'] ?? 'Unknown Name',
                  data['Clinic-Description'] ?? 'No description available',
                  "Opening Hours: ${data['Clinic-OpenHR'] ?? 'Unknown Type'}",
                ),
                const SizedBox(height: 50),
                // Map integration placeholder
                // Uncomment to enable the map with API key
                // Container(height: 200, child: _buildMap()),
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
            : const Center(child: Text('Image not available')),
      ),
    );
  }

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.arrow_back, () => context.go('/clinic')),
          Row(
            children: [
              _buildIconButton(Icons.share, () {}),
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
      iconSize: 30,
      color: Colors.black,
    );
  }

  Widget _buildDetailsSection(
      String name, String description, String clinicType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(name),
          _buildSubtitle(clinicType),
          const SizedBox(height: 16),
          _buildAboutUsSection(description),
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

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  // }

  // Widget _buildMap() {
  //   return GoogleMap(
  //     onMapCreated: _onMapCreated,
  //     initialCameraPosition: CameraPosition(
  //       target: _defaultLocation,
  //       zoom: 15.0,
  //     ),
  //     markers: {
  //       Marker(
  //         markerId: MarkerId('Clinic'),
  //         position: _defaultLocation,
  //         infoWindow: const InfoWindow(title: 'Clinic Location'),
  //       ),
  //     },
  //   );
  // }
}
