import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/BarrelFileWidget..dart';

class HealthInstitutionScreen extends StatefulWidget {
  const HealthInstitutionScreen({super.key});

  @override
  State<HealthInstitutionScreen> createState() =>
      _HealthInstitutionScreenState();
}

class _HealthInstitutionScreenState extends State<HealthInstitutionScreen> {
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  final _futurepublic = Supabase.instance.client
      .from('Health-Institution')
      .select()
      .eq("Health-Institution-Type", "Government Hospital");

  final _futureprivate = Supabase.instance.client
      .from('Health-Institution')
      .select()
      .eq("Health-Institution-Type", "Private Hospital");
  final _futureclinics =
      Supabase.instance.client.from('Clinic-External').select();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'Health\nInstitutions',
            style: GoogleFonts.poppins(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _primaryColor),
            onPressed: () {
              context.go('/homescreen/:userID');
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: "Government Hospital"),
              Tab(text: "Private Hospital"),
              Tab(text: "Clinics"),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            _buildPublicHealthInstitutionsGrid(),
            _buildPrivateHealthInstitutionsGrid(),
            _buildClinicGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicHealthInstitutionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futurepublic,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final healthInst = snapshot.data ?? [];

          if (healthInst.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return SizedBox(
            height: 500,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1 / 1.2,
              ),
              itemCount: healthInst.length,
              itemBuilder: (context, index) => _HealthInstitutionCard(
                healthInstData: healthInst[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivateHealthInstitutionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureprivate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final healthInst = snapshot.data ?? [];

          if (healthInst.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return SizedBox(
            height: 500,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1 / 1.2,
              ),
              itemCount: healthInst.length,
              itemBuilder: (context, index) => _HealthInstitutionCard(
                healthInstData: healthInst[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClinicGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
      child: FutureBuilder(
        future: _futureclinics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final List<Map<String, dynamic>> clinics = snapshot.data ?? [];

          if (clinics.isEmpty) {
            return const Center(child: Text('No clinics available'));
          }

          return SizedBox(
            height: 500,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1 / 1.2,
              ),
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinicData = clinics[index];
                return _buildClinicCard(clinicData);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildClinicCard(Map<String, dynamic> clinicData) {
    return FutureBuilder(
      future: _getClinicImageUrl(clinicData),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final clinicId = clinicData['Clinic-ID'];
            context.go('/Health-Insititution/clinic/$clinicId');
          },
          image: imageUrl,
          title: clinicData['Clinic-Name'] ?? 'Unknown Clinic',
          subtitle: clinicData['Clinic-Type'] ?? 'Unknown Type',
        );
      },
    );
  }

  Future<String> _getClinicImageUrl(Map<String, dynamic> clinicData) async {
    final fileName = "${clinicData['Clinic-Name']}.png";
    return Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");
  }
}

class _HealthInstitutionCard extends StatelessWidget {
  final Map<String, dynamic> healthInstData;

  const _HealthInstitutionCard({required this.healthInstData});

  Future<String> _getImageUrl() async {
    final fileName = "${healthInstData['Health-Institution-Name']}.png";
    return Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return CardDesign1(
          goto: () {
            final id = healthInstData['Health-Institution-ID'];
            context.go('/Health-Insititution/$id');
          },
          image: snapshot.data ?? '',
          title: healthInstData['Health-Institution-Name'] ?? 'Unknown Name',
          subtitle: healthInstData['Health-Institution-Type'] ?? '',
        );
      },
    );
  }
}
