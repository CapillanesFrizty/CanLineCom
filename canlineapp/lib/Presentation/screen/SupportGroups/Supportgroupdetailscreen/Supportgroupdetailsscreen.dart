import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Supportgroupdetailsscreen extends StatefulWidget {
  final String groupName;

  const Supportgroupdetailsscreen({super.key, required this.groupName});

  @override
  State<Supportgroupdetailsscreen> createState() =>
      _SupportgroupdetailsscreenState();
}

class _SupportgroupdetailsscreenState extends State<Supportgroupdetailsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        children: [
          _buildBackgroundImage(''), // Add image URL if available
          _buildDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String imageUrl) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : const Center(child: Text('Image not available')),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        color: const Color(0xff6A5ACD),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(),
        _buildDividerWithSpacing(),
        _buildAboutSection(),
        _buildDividerWithSpacing(),
        _buildMembersSection(),
        _buildDividerWithSpacing(),
        _buildContactSection(),
        _buildDividerWithSpacing(),
        _buildEventsSection(),
        _buildDividerWithSpacing(),
        _buildResourcesSection(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTitle(widget.groupName),
        const SizedBox(height: 10),
        _buildSubtitle('Support Group'),
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

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About Us',
      content:
          'Description about the support group goes here. This section can include the mission, vision, and goals of the group.',
    );
  }

  Widget _buildMembersSection() {
    return _buildSection(
      title: 'Members',
      content: '100 members', // Replace with actual data
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      title: 'Contact Us',
      content: 'https://www.example.com', // Replace with actual URL
      isLink: true,
    );
  }

  Widget _buildEventsSection() {
    return _buildSection(
      title: 'Upcoming Events',
      content: 'Details about upcoming events go here.',
    );
  }

  Widget _buildResourcesSection() {
    return _buildSection(
      title: 'Resources',
      content: 'Links to resources and helpful materials go here.',
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xff5B50A0),
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSection(
      {required String title, required String content, bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 16),
        isLink
            ? Row(
                children: [
                  const Icon(Icons.link, color: Colors.black, size: 25),
                  const SizedBox(width: 10),
                  Text(
                    content,
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.black),
                  ),
                ],
              )
            : Text(
                content,
                style: GoogleFonts.poppins(fontSize: 15),
              ),
        const SizedBox(height: 32),
      ],
    );
  }
}
