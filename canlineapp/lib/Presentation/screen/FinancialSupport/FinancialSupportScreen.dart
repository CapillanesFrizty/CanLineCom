import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/Card/Carddesign2Carousellist.dart';
import 'package:google_fonts/google_fonts.dart';

class FinancialSupportScreen extends StatefulWidget {
  const FinancialSupportScreen({super.key});

  @override
  State<FinancialSupportScreen> createState() => _FinancialSupportScreenState();
}

class _FinancialSupportScreenState extends State<FinancialSupportScreen> {
  /// Future to get the government financial institutions
  final _getGovFinancialInstitution = Supabase.instance.client
      .from('Financial-Institution')
      .select()
      .eq('Financial-Institution-Type', 'Government Institution');

  /// Future to get the private financial institutions
  final _getPrivateFinancialInstitution = Supabase.instance.client
      .from('Financial-Institution')
      .select()
      .eq('Financial-Institution-Type', 'Private Institution');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildSearchField(),
          _buildInstitutionSection(
              "Government Institution", _getGovFinancialInstitution),
          _buildInstitutionSection(
              "Private Institution", _getPrivateFinancialInstitution),
        ],
      ),
    );
  }

  /// Builds the screen title.
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF5B50A0)),
            onPressed: () {
              context.go('/'); // Navigates to the home route instead of popping
            },
          ),
          SizedBox(
              width: 10.0), // Adds some space between the icon and the title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Color(0xFF5B50A0),
                  ),
                ),
              ),
              Text(
                'Assistance',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Color(0xFF5B50A0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the search field for filtering institutions.
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffF3EBFF),
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: Color(0xff5B50A0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xffF3EBFF), width: 1.0), // Border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xff5B50A0), width: 1.5), // Border when focused
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Color(0xff5B50A0), fontSize: 14.0),
        ),
      ),
    );
  }

  /// Builds a section with a title and a grid of institutions.
  Widget _buildInstitutionSection(
      String title, Future<List<Map<String, dynamic>>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
          child: Text(title,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff5B50A0)),
              )),
        ),
        FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            }

            final List<Map<String, dynamic>> institutions = snapshot.data ?? [];

            if (institutions.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                height: 220, // Set a fixed height for horizontal scrolling
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: institutions.length,
                  itemBuilder: (context, index) {
                    final institutionData = institutions[index];
                    return _buildInstitutionCard(institutionData, context);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Fetches the image URL from Supabase storage for a given institution.
  Future<String> _getImageUrl(Map<String, dynamic> institutionData) async {
    final fileName = "${institutionData['Financial-Institution-Name']}.png";
    final response = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Financial-Institution/$fileName");
    debugPrint('Link: $response');
    return response;
  }

  /// Builds a card for each institution, displaying its image and name.
  Widget _buildInstitutionCard(
      Map<String, dynamic> institutionData, BuildContext context) {
    return FutureBuilder(
      future: _getImageUrl(institutionData),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return Carddesign2Carousellist(
          image: imageUrl.isEmpty ? '' : imageUrl,
          goto: () {
            final fid = institutionData['Financial-Institution-ID'];
            debugPrint('Tapped on institution ID: $fid');
            context.go('/Financial-Institution/$fid');
          },
          title:
              institutionData['Financial-Institution-Name'] ?? 'Unknown Name',
        );
      },
    );
  }
}
