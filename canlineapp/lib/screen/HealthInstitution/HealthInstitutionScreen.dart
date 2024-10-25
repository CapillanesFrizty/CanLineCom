import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/BarrelFileWidget..dart';

class HealthInstitutionScreen extends StatelessWidget {
  HealthInstitutionScreen({super.key});

  final _future = Supabase.instance.client.from('health_institutions').select();

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
        style: TextStyle(fontFamily: "Gilroy-Medium", fontWeight: FontWeight.w500, fontSize: 30.0, color: Color(0xFF5B50A0)),
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
          fillColor: Colors.grey.shade100,
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

  Widget _buildHealthInstitutionCard(Map<String, dynamic> healthInstData, BuildContext context) {
    return CardDesign1(
      goto: () {
        final id = healthInstData['id'];
        debugPrint('ID: $id');
        context.go('/Health-Insititution/$id');
      },
      title: healthInstData['name_of_health_institution'] ?? 'Unknown Name',
      subtitle: healthInstData['type_of_hospital'] ?? 'Unknown Type',
    );
  }
}
