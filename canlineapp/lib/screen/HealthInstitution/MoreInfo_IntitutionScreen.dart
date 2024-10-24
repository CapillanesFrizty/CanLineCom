import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class MoreInfoInstitutionScreen extends StatefulWidget {
  final String id;
  const MoreInfoInstitutionScreen({super.key, required this.id});

  @override
  State<MoreInfoInstitutionScreen> createState() =>
      _MoreInfoInstitutionScreenState();
}

class _MoreInfoInstitutionScreenState extends State<MoreInfoInstitutionScreen> {
  // Set the value as needed
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client
        .from('health_institutions')
        .select()
        .eq('id', widget.id)
        .single();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while waiting for data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any errors that occur
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Render the fetched data
                final data = snapshot.data;

                return Column(
                  children: [
                    // Image section at the top
                    _buildImageSection(context),
                    const SizedBox(height: 20), // Space below the image
                    // Details section containing title, subtitle, facilities box, and about us
                    _buildDetailsSection(data["name_of_health_institution"],
                        data["description"], data["type_of_hospital"]),
                    SizedBox(height: 50), // Space below the details section

                    // TODO: Add more here sections as needed
                  ],
                );
              } else {
                // Handle case where there is no data
                return Center(child: Text('No data found'));
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget to build the image section with an overlay for icons
  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            child: Image.asset(
              'lib/assets/images/jpeg/spmc.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay icons for navigation and actions
        _buildTopIcons(context),
      ],
    );
  }

  // Widget to build the top action icons
  Widget _buildTopIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            onPressed: () {
              context.go('/Health-Insititution');
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            color: Colors.black,
          ),
          // Share and favorite buttons
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Handle share action
                },
                icon: const Icon(Icons.share),
                iconSize: 30,
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  // Handle favorite action
                },
                icon: const Icon(Icons.favorite_outline),
                iconSize: 30,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget to build the details section containing title, subtitle, and facilities
  Widget _buildDetailsSection(
      String name, String description, String type_of_hospital) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          _buildTitle(name),
          // Subtitle
          _buildSubtitle(type_of_hospital),
          const SizedBox(height: 16), // Space below subtitle
          // Facilities box with info columns
          _buildFacilitiesBox(),
          const SizedBox(height: 16), // Space below facilities box
          // About Us section
          _buildAboutUsSection(description),
        ],
      ),
    );
  }

  // Widget to build the title
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget to build the subtitle
  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(fontSize: 18, color: Colors.grey),
    );
  }

  // Widget to build the facilities box
  Widget _buildFacilitiesBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoColumn('Facilities', '10'), // Facilities count
          const VerticalDivider(), // Divider between info columns
          _infoColumn(
              'Accredited Insurance', '5'), // Accredited insurance count
          const VerticalDivider(), // Divider
          _infoColumn('Doctors', '20'), // Doctors count
        ],
      ),
    );
  }

  // Widget to build the About Us section
  Widget _buildAboutUsSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8), // Space below the heading
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Helper method to build info columns for facilities
  Widget _infoColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
