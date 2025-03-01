import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalSpeciaDetailScreens extends StatefulWidget {
  final String docid;
  const MedicalSpeciaDetailScreens({super.key, required this.docid});

  @override
  State<MedicalSpeciaDetailScreens> createState() =>
      _MedicalSpeciaDetailScreensState();
}

class _MedicalSpeciaDetailScreensState
    extends State<MedicalSpeciaDetailScreens> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchDoctorDetails();
  }

  Future<Map<String, dynamic>> _fetchDoctorDetails() async {
    if (widget.docid == null || widget.docid.isEmpty) {
      throw Exception('Invalid doctor ID');
    }
    print('Received doctor ID: ${widget.docid}');
    try {
      // Simplified ID handling - no need to parse twice
      final doctorId = int.tryParse(widget.docid);
      if (doctorId == null) {
        throw Exception('Invalid doctor ID format');
      }

      final response = await Supabase.instance.client
          .from('Doctor')
          .select()
          .eq('id', doctorId) // Use the parsed integer directly
          .single();

      if (response == null) {
        throw Exception('No data found');
      }

      // Rest of the code remains the same
      // final fileName =
      //     "${response['Doctor-Firstname']}_${response['Doctor-Lastname']}.png";
      // final imageUrl = Supabase.instance.client.storage
      //     .from('Assets')
      //     .getPublicUrl("Doctor/$fileName");

      // response['Doctor-Image-Url'] = imageUrl;
      return response;
    } catch (e) {
      throw Exception('Failed to fetch doctor details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => context.go('/Medical-Specialists'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDoctorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                _buildBackgroundImage(),
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

  Widget _buildBackgroundImage() {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        child: Center(
            child: Icon(Icons.person_4_rounded, color: Colors.grey, size: 300)),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
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
          _buildHeaderSection(data),
          _buildDividerWithSpacing(),
          _buildAboutSection(data),
          _buildDividerWithSpacing(),
          _buildContactSection(data),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTitle('${data['Doctor-Firstname']} ${data['Doctor-Lastname']}'),
        const SizedBox(height: 10),
        _buildSubtitle(data['Specialization'] ?? 'Unknown Specialization'),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDividerWithSpacing() {
    return Column(
      children: const [
        Divider(color: Colors.black),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xff5B50A0),
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['Medical Background'] ?? 'No description available',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildContactSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Number',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['Doctor-Contact-Number'] ?? 'no COntact Number available',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }
}
