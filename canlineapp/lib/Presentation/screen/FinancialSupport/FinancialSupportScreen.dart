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
      fontSize: 18.0, // Match font size to BlogsScreen
      fontWeight: FontWeight.bold,
      color: _primaryColor,
    ),
  );

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentCategoryIndex = 0;

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
        .from('Financial-Institution')
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

  Future<void> _refreshInstitutions() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshInstitutions,
        child: Column(
          children: [
            _buildSearchBarWithFilter(),
            const SizedBox(height: 30),
            Expanded(
              child: _buildCurrentCategoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarWithFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: _primaryColor),
          suffixIcon: PopupMenuButton<int>(
            icon: Icon(Icons.filter_list, color: _primaryColor),
            onSelected: (int index) {
              setState(() {
                _currentCategoryIndex = index;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: Text('Government', style: GoogleFonts.poppins()),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Private', style: GoogleFonts.poppins()),
              ),
            ],
          ),
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

  Widget _buildCurrentCategoryList() {
    if (_currentCategoryIndex == 0) {
      return _buildInstitutionSection("Government Institution");
    } else {
      return _buildInstitutionSection("Private Institution");
    }
  }

  Widget _buildInstitutionSection(String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchInstitutions(type),
      builder: (context, snapshot) {
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: institutions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: _buildInstitutionCard(institutions[index]),
            );
          },
        );
      },
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
          category: institution['Financial-Institution-Type'] ??
              'Unknown Type', // Add this line
        );
      },
    );
  }
}
