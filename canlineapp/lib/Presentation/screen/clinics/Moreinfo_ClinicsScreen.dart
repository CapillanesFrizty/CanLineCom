import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late Future<Map<String, dynamic>> _clinicDetailsFuture;
  static const LatLng _center = LatLng(7.099091, 125.616108);
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _clinicDetailsFuture = _fetchClinicDetails();
  }

  Future<Map<String, dynamic>> _fetchClinicDetails() async {
    final response = await Supabase.instance.client
        .from('Clinic-External')
        .select()
        .eq('Clinic-ID', widget.id)
        .single();

    final fileName = "${response['Clinic-Name']}.png";
    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");

    response['Clinic-Image-Url'] = imageUrl;
    return response;
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
                _buildDetailsSection(
                  name: data['Clinic-Name'] ?? 'Unknown Name',
                  description:
                      data['Clinic-Description'] ?? 'No description available',
                  type: data['Clinic-Type'] ?? 'Unknown Type',
                  address: data['Clinic-Address'] ?? 'Unknown Address',
                ),
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
      height: 250,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : const Center(child: Text('Image not available')),
      ),
    );
  }

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.arrow_back, () => context.go('/clinic')),
          Row(
            children: [
              _buildIconButton(Icons.share, () {}),
              const SizedBox(width: 10.0),
              _buildIconButton(Icons.favorite_border, () {}),
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
      color: AppColors.primary,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(AppColors.background),
      ),
    );
  }

  Widget _buildDetailsSection({
    required String name,
    required String description,
    required String type,
    required String address,
  }) {
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
          const Divider(color: AppColors.divider, thickness: 1),
          _buildAboutUsSection(description),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, thickness: 1),
          _buildScheduleSection(),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, thickness: 1),
          _buildFacilitiesSection(),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, thickness: 1),
          _buildLocationSection(),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, thickness: 1),
          _buildAccreditedInsurancesSection(),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(fontSize: 16, color: AppColors.secondary),
    );
  }

  Widget _buildAboutUsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Us',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        SizedBox(height: 10),
        Text(
          'Monday - Saturday 9:00am - 6:00pm',
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Facilities',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Dedicated to providing specialized care for cancer patients. With advanced treatments, compassionate support, and a team of expert oncologists, we are here to guide you every step of the way on your journey to healing.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildFacilityCard(),
      ],
    );
  }

  Widget _buildFacilityCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.medical_services_outlined,
              size: 40, color: AppColors.primary),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultant Oncologists',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Patient Consultant',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildAccreditedInsurancesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accredited Insurances',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Where we collaborate with leading accredited insurance providers to ensure seamless access to quality cancer care. Your well-being is our priority, and we’re here to support you every step of the way.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildInsuranceCard(
          'PhilHealth',
          'Philippine Health Insurance Corporation Services',
          'https://via.placeholder.com/50', // Replace with actual logo URL
        ),
      ],
    );
  }

  Widget _buildInsuranceCard(String name, String description, String logoUrl) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(logoUrl, width: 50, height: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
