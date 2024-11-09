import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthInstitutionOncologists extends StatefulWidget {
  final String id;

  const HealthInstitutionOncologists({super.key, required this.id});

  @override
  State<HealthInstitutionOncologists> createState() =>
      _HealthInstitutionOncologistsState();
}

class _HealthInstitutionOncologistsState
    extends State<HealthInstitutionOncologists> {
  late Future<List<dynamic>> _futureDoctors;
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  @override
  void initState() {
    super.initState();
    _futureDoctors = _fetchDoctors();
  }

  Future<List<dynamic>> _fetchDoctors() async {
    final response = await Supabase.instance.client
        .from('Doctor')
        .select()
        .eq('Affailated_at', widget.id);

    debugPrint('Doctors: $response');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureDoctors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Doctors available.'));
        }

        final doctors = snapshot.data!;

        return Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              itemCount: doctors.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                    ],
                  );
                }

                final Doctors = doctors[index - 1];
                return Column(
                  children: [
                    _buildConsultationCard(
                        Icons.health_and_safety,
                        Doctors['Doctor-Firstname'] +
                            ' ' +
                            Doctors['Doctor-Lastname'],
                        Doctors['Specialization']),
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
            'Doctors and Oncologists',
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
            'Sample Description',
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

  Widget _buildConsultationCard(IconData icon, String title, String subtitle) {
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
