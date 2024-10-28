import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:canerline_app/Presentation/widgets/Card/CardDesign1.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  final _clinicFuture =
      Supabase.instance.client.from('Clinic-External').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 10),
              _buildSearchField(),
              const SizedBox(height: 20),
              _buildClinicGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Build the title widget
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        "Clinics",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5B50A0),
        ),
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField() {
    return TextField(
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.zero,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
      ),
    );
  }

  // Build the grid of clinics using FutureBuilder
  Widget _buildClinicGrid() {
    return FutureBuilder(
      future: _clinicFuture,
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
          height: 450,
          child: GridView.builder(
            itemCount: clinics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.2,
            ),
            itemBuilder: (context, index) {
              final clinicData = clinics[index];
              return _buildClinicCard(clinicData);
            },
          ),
        );
      },
    );
  }

  // Build each clinic card with navigation and data handling
  Widget _buildClinicCard(Map<String, dynamic> clinicData) {
    return FutureBuilder(
      future: _getImageUrl(clinicData),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final clinicId = clinicData['Clinic-ID'];
            context.go('/clinic/$clinicId');
          },
          image: imageUrl,
          title: clinicData['Clinic-Name'] ?? 'Unknown Clinic',
          subtitle: clinicData['Clinic-Type'] ?? 'Unknown Type',
        );
      },
    );
  }

  // Get the image URL for a clinic
  Future<String> _getImageUrl(Map<String, dynamic> clinicData) async {
    final fileName = "${clinicData['Clinic-Name']}.png";
    final response = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Clinic-External/$fileName");
    debugPrint("Fetched image URL: $response");

    return response;
  }
}
