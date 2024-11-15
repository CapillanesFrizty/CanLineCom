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

  final _future = Supabase.instance.client.from('Health-Institution').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(bottom: 20.0), // Extra padding for safety
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            _buildSearchField(),
            _buildFilterButtons(),
            const SizedBox(height: 20),
            _buildSectionTitle('Health Institutions'),
            const SizedBox(height: 16),
            _buildHealthInstitutionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
      color: _primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Health', style: titleStyle),
          Text('Institutions', style: titleStyle),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: GoogleFonts.poppins(color: _primaryColor),
          prefixIcon: Icon(Icons.search, color: _primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: _primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Row(
        children: const [
          _FilterButton(text: 'Government Hospital', color: _primaryColor),
          SizedBox(width: 8),
          _FilterButton(text: 'Private Hospital', color: _primaryColor),
        ],
      ),
    );
  }

  Widget _buildHealthInstitutionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
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
}

class _FilterButton extends StatelessWidget {
  final String text;
  final Color color;
  const _FilterButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: GoogleFonts.poppins(color: color),
      ),
    );
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
