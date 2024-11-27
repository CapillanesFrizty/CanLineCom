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
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _MoreInfoInstitutionScreenState extends State<MoreInfoInstitutionScreen> {
  late Future<Map<String, dynamic>> _future;
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

    final number_of_facilities = await Supabase.instance.client
        .from('Health-Institution-Service')
        .select("*")
        .eq('Health-Institution-ID', widget.id)
        .count(CountOption.exact);

    final number_of_doctors = await Supabase.instance.client
        .from('Doctor')
        .select("*")
        .eq('Affailated_at', widget.id)
        .count(CountOption.exact);

    final number_of_acredited_insurances = await Supabase.instance.client
        .from('Health-Institution-Accredited-Insurance')
        .select("*")
        .eq('Health-Instiution', widget.id)
        .count(CountOption.exact);

    final number_of_doctor = number_of_doctors.count as int?;
    final number_of_Facilities = number_of_facilities.count as int?;
    final number_of_acredited_insurance =
        number_of_acredited_insurances.count as int?;

    response['Facilities'] = number_of_Facilities;
    response['Doctors'] = number_of_doctor;
    response['Accredited-Insurance'] = number_of_acredited_insurance;
    response['Health-Institution-Image-Url'] = imageUrl;

    debugPrint(
        'GEOLOCATION: ${response['Health-Institution-Address-Lat']},${response['Health-Institution-Address-Long']}');
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
              Icons.arrow_back, () => context.go('/Health-Institution')),
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
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
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
          const SizedBox(height: 16),
          _buildTitle(data['Health-Institution-Name'] ?? 'Unknown Name'),
          const SizedBox(height: 16),
          _buildSubtitle(data['Health-Institution-Type'] ?? 'Unknown Type'),
          const SizedBox(height: 16),
          _buildFacilitiesBox(data['Facilities'] ?? '0', data['Doctors'] ?? '0',
              data['Accredited-Insurance'] ?? '0'),
          const SizedBox(height: 16),
          _buildAboutUsSection(
              data['Health-Institution-Desc'] ?? 'No description available'),
          const SizedBox(height: 16),
          _buildContactUsSection(),
          const SizedBox(height: 16),
          _buildScheduleSection(),
          const SizedBox(height: 16),
          _buildMapSection(
            data['Health-Institution-Address'],
            data['Health-Institution-Address-Lat'] ?? 0.0, // Ensure double
            data['Health-Institution-Address-Long'] ?? 0.0, // Ensure double
            data['Health-Institution-Name'],
          ),
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

  Widget _buildFacilitiesBox(param0, param1, param2) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFacilityItem(
              title: 'Facilities',
              value: param0.toString(),
              type: 'Facilities'),
          const VerticalDivider(thickness: 5, color: Color(0xff5B50A0)),
          _buildFacilityItem(
              title: 'Accredited Insurance',
              value: param1.toString(),
              type: 'Accredited-Insurance'),
          const VerticalDivider(),
          _buildFacilityItem(
              title: 'Doctors', value: param2.toString(), type: 'Doctors'),
        ],
      ),
    );
  }

  Widget _buildFacilityItem({
    required String title,
    required String type,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => context.go('/Health-Insititution/${widget.id}/$type'),
      child: _buildClickableInfoColumn(title, value),
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
            decoration: TextDecoration.underline,
          ),
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
}
