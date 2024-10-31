import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/BarrelFileWidget..dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildSearchField(),
            _buildFilterButtons(),
            _buildHealthInstitutionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      color: _primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: _secondaryColor,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(Icons.search, color: _primaryColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: _secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: _primaryColor, width: 1.5),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(color: _primaryColor, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: const [
          _FilterButton(text: 'Government Hospital'),
          SizedBox(width: 5),
          _FilterButton(text: 'Private Hospital'),
        ],
      ),
    );
  }

  Widget _buildHealthInstitutionsGrid() {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.2,
            ),
            itemCount: healthInst.length,
            itemBuilder: (context, index) => _HealthInstitutionCard(
              healthInstData: healthInst[index],
            ),
          ),
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;

  const _FilterButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(text),
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
