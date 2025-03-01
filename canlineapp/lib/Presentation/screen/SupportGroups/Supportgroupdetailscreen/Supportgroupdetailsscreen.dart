import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Supportgroupdetailsscreen extends StatefulWidget {
  final String groupId; // Add this line

  const Supportgroupdetailsscreen({
    super.key,
    required this.groupId, // Add this line
  });

  @override
  State<Supportgroupdetailsscreen> createState() =>
      _SupportgroupdetailsscreenState();
}

class _SupportgroupdetailsscreenState extends State<Supportgroupdetailsscreen> {
  late Future<Map<String, dynamic>> _supportGroupFuture;

  @override
  void initState() {
    super.initState();
    _supportGroupFuture = _fetchSupportGroup();
  }

  // Modify return type to Map<String, dynamic>
  Future<Map<String, dynamic>> _fetchSupportGroup() async {
    try {
      final response = await Supabase.instance.client
          .from('Support_Groups')
          .select()
          .eq("id", widget.groupId)
          .single();

      // Get the image URL from storage bucket
      if (response != null && response['Group_name'] != null) {
        // Sanitize the filename
        final fileName =
            '${response['Group_name']}.png'; // Remove special characters

        final String imageUrl = Supabase.instance.client.storage
            .from('Assets') // Your bucket name
            .getPublicUrl(
                "Support-Groups/$fileName"); // Direct filename without extra folders

        // Add the image URL to the response
        return {
          ...response,
          'image_url': imageUrl,
        };
      }
      return response;
    } catch (e) {
      debugPrint('Error fetching support group: $e');
      throw Exception('Failed to fetch support group details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => context.go('/Support-Groups'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _supportGroupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No data found',
                style: GoogleFonts.poppins(),
              ),
            );
          }

          final groupData = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            children: [
              _buildBackgroundImage(groupData['image_url'] ?? ''),
              _buildDetailsSection(
                category: groupData['Group_category'] ?? '',
                groupName: groupData['Group_name'] ?? '',
                description: groupData['Group_description'] ?? '',
                events: groupData['events'] ?? 'No upcoming events',
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildBottomNavBar() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _supportGroupFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final websiteUrl = snapshot.data!['url'] ?? '';

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
                  debugPrint('Opening website: $websiteUrl');
                  try {
                    if (websiteUrl.isNotEmpty) {
                      final url = Uri.parse(websiteUrl);
                      await _launchInBrowserView(url);
                    } else {
                      throw Exception('Website URL is empty');
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.white),
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
      },
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

  Widget _buildDetailsSection({
    required String groupName,
    required String description,
    required String category,
    required String events,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(groupName: groupName, category: category),
        _buildDividerWithSpacing(),
        _buildAboutSection(description: description),
        _buildDividerWithSpacing(),
        _buildEventsSection(events: events),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeaderSection(
      {required String groupName, required String category}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTitle(groupName),
        const SizedBox(height: 10),
        _buildSubtitle(category),
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

  Widget _buildAboutSection({required String description}) {
    return _buildSection(
      title: 'About Us',
      content: description,
    );
  }

  Widget _buildEventsSection({required String events}) {
    return _buildSection(
      title: 'Upcoming Events',
      content: events,
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
