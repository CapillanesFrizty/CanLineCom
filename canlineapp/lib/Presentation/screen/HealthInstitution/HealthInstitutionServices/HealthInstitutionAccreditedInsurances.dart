import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthInstitutionAccreditedInsurances extends StatefulWidget {
  final String id;

  const HealthInstitutionAccreditedInsurances({super.key, required this.id});

  @override
  State<HealthInstitutionAccreditedInsurances> createState() =>
      _HealthInstitutionAccreditedInsurancesState();
}

class _HealthInstitutionAccreditedInsurancesState
    extends State<HealthInstitutionAccreditedInsurances> {
  late Future<List<dynamic>> _futureAccreditedInsurances;
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  @override
  void initState() {
    super.initState();
    _futureAccreditedInsurances = _fetchAcredittedInsurances();
  }

  Future<List<dynamic>> _fetchAcredittedInsurances() async {
    final response = await Supabase.instance.client
        .from('Health-Institution-Accredited-Insurance')
        .select(
            'Health-Institution(Health-Institution-ID), Financial-Institution(Financial-Institution-Name, Financial-Institution-Desc)')
        .eq('Health-Instiution', widget.id);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureAccreditedInsurances,
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

          final acreditedInssurance = snapshot.data!;

          return Scaffold(
            body: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                itemCount: acreditedInssurance.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                      ],
                    );
                  }

                  final AccreditedInsurances = acreditedInssurance[index - 1];
                  return Column(
                    children: [
                      _buildServiceCard(
                        Icons.health_and_safety,
                        AccreditedInsurances['Financial-Institution']
                            ['Financial-Institution-Name'],
                        AccreditedInsurances['Financial-Institution']
                            ['Financial-Institution-Desc'],
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Center(
          child: Text(
            'Acredited Insurances',
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
            'Sample data',
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

  Widget _buildMainServiceCard() {
    return _buildServiceCard(
      Icons.health_and_safety,
      'Sample data',
      "Sample",
    );
  }

  Widget _buildConsultationCard() {
    return _buildServiceCard(
      Icons.person,
      'Sample data',
      'Patient Consultant',
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
