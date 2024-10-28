import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/BarrelFileWidget..dart';

class HealthInstitutionScreen extends StatefulWidget {
  const HealthInstitutionScreen({super.key});

  @override
  State<HealthInstitutionScreen> createState() =>
      _HealthInstitutionScreenState();
}

class _HealthInstitutionScreenState extends State<HealthInstitutionScreen> {
  final _future = Supabase.instance.client.from('Health-Institution').select();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildSearchField(),
          _buildFilterButtons(),
          _buildHealthInstitutionsGrid(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(30.0),
      child: Text(
        "Health Institution",
        style: TextStyle(
            fontFamily: "Gilroy-Medium",
            fontWeight: FontWeight.w500,
            fontSize: 30.0,
            color: Color(0xFF5B50A0)),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(245, 245, 245, 1),
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Row(
        children: [
          _buildFilterButton('Government Hospital'),
          const SizedBox(width: 5),
          _buildFilterButton('Private Hospital'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text),
    );
  }

  Widget _buildHealthInstitutionsGrid() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        final List<Map<String, dynamic>> healthInst = snapshot.data ?? [];

        if (healthInst.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SizedBox(
            height: 500,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1 / 1.2,
              ),
              itemCount: healthInst.length,
              itemBuilder: (context, index) {
                final healthInstData = healthInst[index];
                return _buildHealthInstitutionCard(healthInstData, context);
              },
            ),
          ),
        );
      },
    );
  }

  Future<String> _getImageUrl(Map<String, dynamic> healthInstData) async {
    final fileName = "${healthInstData['Health-Institution-Name']}.png";
    final response = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Health-Institution/$fileName");
    debugPrint("ERROR: $response and the filename is: $fileName");

    return response;
  }

  Widget _buildHealthInstitutionCard(
      Map<String, dynamic> healthInstData, BuildContext context) {
    return FutureBuilder(
      future: _getImageUrl(healthInstData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final imageUrl = snapshot.data ?? '';

        return CardDesign1(
          goto: () {
            final id = healthInstData['Health-Institution-ID'];
            debugPrint('ID: $id');
            context.go('/Health-Insititution/$id');
          },
          image: imageUrl.isEmpty ? '' : imageUrl,
          title: healthInstData['Health-Institution-Name'] ?? 'Unknown Name',
          subtitle: healthInstData['Health-Institution-Type'] ?? '',
        );
      },
    );
  }
}
