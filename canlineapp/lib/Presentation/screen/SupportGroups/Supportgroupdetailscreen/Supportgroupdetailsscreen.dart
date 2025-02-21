import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Supportgroupdetailsscreen extends StatefulWidget {
  final String groupName;
  final String description;
  final String category;
  final String members;
  final String url;

  const Supportgroupdetailsscreen({
    super.key,
    required this.groupName,
    required this.description,
    required this.category,
    required this.members,
    required this.url,
  });

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
          () => context.go('/Support-Groups'),
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
      bottomNavigationBar: _buildBottomNavBar(), // Add this line
    );
  }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff6A5ACD), Color(0xff5B50A0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff6A5ACD).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              try {
                final url = Uri.parse(widget.url);
                await _launchInBrowserView(url);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Could not open website',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 22,
                    color: Colors.white.withOpacity(0.95),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Visit Website',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      content: widget.description,
    );
  }

  Widget _buildMembersSection() {
    return _buildSection(
      title: 'Members',
      content: widget.members,
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      title: 'Contact Us',
      content: widget.url,
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
