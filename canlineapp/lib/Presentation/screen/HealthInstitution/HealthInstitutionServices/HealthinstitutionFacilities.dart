import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthInstitutionFacilities extends StatefulWidget {
  final String id;

  const HealthInstitutionFacilities({super.key, required this.id});

  @override
  State<HealthInstitutionFacilities> createState() =>
      _HealthInstitutionFacilitiesState();
}

class _HealthInstitutionFacilitiesState
    extends State<HealthInstitutionFacilities> {
  late Future<List<dynamic>> _futureFacilities;
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  @override
  void initState() {
    super.initState();
    _futureFacilities = _fetchInstitutionFacilities();
  }

  Future<List<dynamic>> _fetchInstitutionFacilities() async {
    final response = await Supabase.instance.client
        .from('Health-Institution-Service')
        .select(
            'Health-Institution-Service-ID, Health-Institution-Service-Name, Health-Institution-Service-Desc')
        .eq('Health-Institution-ID', widget.id);

    debugPrint('Facilities: $response');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _futureFacilities,
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

        final facilities = snapshot.data!;

        return Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              itemCount: facilities.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                    ],
                  );
                }

                final facility = facilities[index - 1];
                return Column(
                  children: [
                    _buildServiceCard(
                      Icons.health_and_safety,
                      facility['Health-Institution-Service-Name'],
                      facility['Health-Institution-Service-Desc'],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Center(
          child: Text(
            'Services',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: Text(
            'Sample Data',
            style: TextStyle(
              fontSize: 12,
              color: _primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: _primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: _primaryColor.withOpacity(0.7),
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
