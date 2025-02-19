import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);
}

class _EventsScreenState extends State<EventsScreen> {
  final _getEvents = Supabase.instance.client.from('Events').select();
  final TextEditingController _searchController = TextEditingController();
  // String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(bottom: 20.0), // Extra padding for safety
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 30),
            // _buildSearchBar(),

            // _buildSectionTitle('Latest Events'),
            // const SizedBox(height: 30),
            // _buildPopularBlogs(),
            // const SizedBox(height: 20),
            // _buildSectionTitle('Other Events'),
            const SizedBox(height: 30),
            _buildRecentBlogsSection(),
          ],
        ),
      ),
    );
  }

  // ? Parked for now, will be implemented in the future
  // Widget _buildSectionTitle(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //     child: Text(
  //       title,
  //       style: GoogleFonts.poppins(
  //         color: EventsScreen._primaryColor,
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //     child: TextField(
  //       controller: _searchController,
  //       onChanged: (query) {
  //         setState(() {
  //           _searchQuery = query;
  //         });
  //       },
  //       decoration: InputDecoration(
  //         hintText: 'Search',
  //         prefixIcon:
  //             const Icon(Icons.search, color: EventsScreen._primaryColor),
  //         suffixIcon:
  //             const Icon(Icons.filter_list, color: EventsScreen._primaryColor),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: EventsScreen._primaryColor),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: EventsScreen._primaryColor),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: EventsScreen._primaryColor),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildLatestEvents) {
  //   return SizedBox(
  //     height: 200,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 35.0),
  //       children: [
  //         _buildLatestEvents(
  //           date: 'Aug 7, 2024',
  //           title: 'Balancing the right treatments for metastatic cancer',
  //           author: 'Karl Wood',
  //         ),
  //         const SizedBox(width: 16),
  //         _buildLatestEvents(
  //           date: 'September 19, 2024',
  //           title: 'Therapy customized through stem cell treatments',
  //           author: 'Jane Doe',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRecentBlogsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: FutureBuilder(
        future: _getEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          final Eventsdata = snapshot.data as List<Map<String, dynamic>>;
          if (Eventsdata.isEmpty) {
            return const Center(child: Text('No available events yet'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Eventsdata.length,
            itemBuilder: (context, index) {
              return _buildRecentBlogCard(Eventsdata[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentBlogCard(Map<String, dynamic> Eventsdata) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.white70, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Eventsdata['Event_Organizer'],
                    style: GoogleFonts.poppins(
                      color: EventsScreen._primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Eventsdata['Event_name'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EventsScreen._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${Eventsdata['Event_Date']}, ${Eventsdata['Event_Time']}',
                    style: GoogleFonts.poppins(
                      color: EventsScreen._primaryColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: 15),
            // Icon(Icons.favorite_border, color: BlogsScreen._primaryColor),
          ],
        ),
      ),
    );
  }
}
