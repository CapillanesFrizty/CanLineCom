import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoreinfoEventsscreen extends StatefulWidget {
  final String id;
  final String userid; // Add this line
  const MoreinfoEventsscreen({
    super.key,
    required this.id,
    required this.userid, // Add this line
  });

  @override
  State<MoreinfoEventsscreen> createState() => _MoreinfoEventsscreenState();
}

class _MoreinfoEventsscreenState extends State<MoreinfoEventsscreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchEventDetails();
  }

  Future<Map<String, dynamic>> _fetchEventDetails() async {
    debugPrint('Fetching event details for event ID: ${widget.id}');
    final response = await Supabase.instance.client
        .from('Events')
        .select()
        .eq('Event_id', int.parse(widget.id))
        .single();

    final imageUrl = Supabase.instance.client.storage
        .from('Assets')
        .getPublicUrl("Events/${response['Event-Image']}");

    response['Event-Image-Url'] = imageUrl;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => context.go('/EventsScreen'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchEventDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                _buildEventImage(data['Event-Image-Url']),
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

  Widget _buildEventImage(String imageUrl) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.event, color: Colors.grey, size: 300),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: IconButton(
        onPressed: () => context
            .go('/HomeScreen/${widget.userid}/resources'), // Update this line
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
          _buildDetailsContent(data),
          _buildDividerWithSpacing(),
          _buildLocationSection(data),
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
        _buildTitle(data['Event-Name'] ?? 'Untitled Event'),
        const SizedBox(height: 10),
        _buildSubtitle(data['Event-Type'] ?? 'Event Type Not Specified'),
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

  Widget _buildDetailsContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['Event-Description'] ?? 'No description available',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.black, size: 20),
            const SizedBox(width: 10),
            Text(
              data['Event-Date'] ?? 'Date not specified',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.black, size: 20),
            const SizedBox(width: 10),
            Text(
              data['Event-Time'] ?? 'Time not specified',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: Colors.black, size: 25),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                data['Event-Location'] ?? 'Location not specified',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
