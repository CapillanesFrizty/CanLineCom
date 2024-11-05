import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/Card/Carddesign2Carousellist.dart';

class FinancialSupportScreen extends StatefulWidget {
  const FinancialSupportScreen({super.key});

  @override
  State<FinancialSupportScreen> createState() => _FinancialSupportScreenState();
}

class _FinancialSupportScreenState extends State<FinancialSupportScreen> {
  // Constants
  static const _primaryColor = Color(0xFF5B50A0);
  static const _secondaryColor = Color(0xFFF3EBFF);
  static const _tableName = 'Financial-Institution';
  static const double _cardHeight = 200.0;

  // Styles
  final _titleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 30.0,
      color: _primaryColor,
    ),
  );

  final _sectionTitleStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: _primaryColor,
    ),
  );

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Data Fetching
  Future<List<Map<String, dynamic>>> _fetchInstitutions(String type) async {
    final response = await Supabase.instance.client
        .from(_tableName)
        .select()
        .eq('Financial-Institution-Type', type);

    final institutions = List<Map<String, dynamic>>.from(response);

    if (_searchQuery.isEmpty) return institutions;

    return institutions.where((institution) {
      return institution['Financial-Institution-Name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<String> _getImageUrl(Map<String, dynamic> institution) async {
    final fileName = "${institution['Financial-Institution-Name']}.png";
    return Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Financial-Institution/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ListView(
        children: [
          _buildTitle(),
          _buildSearchField(),
          _buildInstitutionSection(
              "Government Institution", "Government Institution"),
          _buildInstitutionSection(
              "Private Institution", "Private Institution"),
        ],
      ),
    );
  }

  // UI Components
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial', style: _titleStyle),
          Text('Assistance', style: _titleStyle),
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
        controller: _searchController,
        decoration: _buildSearchDecoration(),
      ),
    );
  }

  InputDecoration _buildSearchDecoration() {
    return InputDecoration(
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
    );
  }

  Widget _buildInstitutionSection(String title, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(title, style: _sectionTitleStyle),
        ),
        SizedBox(
          height: _cardHeight,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchInstitutions(type),
            builder: _buildInstitutionList,
          ),
        ),
      ],
    );
  }

  Widget _buildInstitutionList(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final institutions = snapshot.data ?? [];
    if (institutions.isEmpty) {
      return const Center(child: Text('No institutions found'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: institutions.length,
      itemBuilder: (context, index) =>
          _buildInstitutionCard(institutions[index]),
    );
  }

  Widget _buildInstitutionCard(Map<String, dynamic> institution) {
    return FutureBuilder<String>(
      future: _getImageUrl(institution),
      builder: (context, snapshot) {
        return Carddesign2Carousellist(
          image: snapshot.data ?? '',
          goto: () => context.go(
            '/Financial-Institution/${institution['Financial-Institution-ID']}',
          ),
          title: institution['Financial-Institution-Name'] ?? 'Unknown Name',
        );
      },
    );
  }
}
