import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoreInfoInstitutionScreen extends StatefulWidget {
  final String id;
  const MoreInfoInstitutionScreen({super.key, required this.id});

  @override
  State<MoreInfoInstitutionScreen> createState() => _MoreInfoInstitutionScreenState();
}

class _MoreInfoInstitutionScreenState extends State<MoreInfoInstitutionScreen> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchInstitutionDetails();
  }

  Future _fetchInstitutionDetails() {
    return Supabase.instance.client
        .from('health_institutions')
        .select()
        .eq('id', widget.id)
        .single();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView(
              children: [
                _buildImageSection(),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  data['name_of_health_institution'] ?? 'Unknown Name',
                  data['description'] ?? 'No description available',
                  data['type_of_hospital'] ?? 'Unknown Type',
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

  Widget _buildImageSection() {
    return Stack(
      children: [
        _buildBackgroundImage(),
        _buildTopIcons(),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ClipRRect(
        child: Image.asset(
          'lib/assets/images/jpeg/spmc.jpg',
          fit: BoxFit.cover,
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
          _buildIconButton(Icons.arrow_back, () => context.go('/Health-Insititution')),
          Row(
            children: [
              _buildIconButton(Icons.share, () {}), // Placeholder for share action
              _buildIconButton(Icons.favorite_outline, () {}), // Placeholder for favorite action
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

  Widget _buildDetailsSection(String name, String description, String hospitalType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(name),
          _buildSubtitle(hospitalType),
          const SizedBox(height: 16),
          _buildFacilitiesBox(),
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
          _buildInfoColumn('Facilities', '10'),
          const VerticalDivider(thickness: 5, color: Colors.black),
          _buildInfoColumn('Accredited Insurance', '5'),
          const VerticalDivider(),
          _buildInfoColumn('Doctors', '20'),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAboutUsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Us', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
