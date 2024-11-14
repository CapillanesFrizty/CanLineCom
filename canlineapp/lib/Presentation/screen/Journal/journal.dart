import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color primaryColor = Color(0xFF5B50A0);
  static const Color secondaryColor = Color(0xFFFF0000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomTab(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // Set the height here
      child: AppBar(
        title: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: const Text(
            'Journal',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white, // Set the background color to white
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          const _DateSection(
              date: 'NOV 13',
              day: 'Today',
              weekday: 'Wednesday',
              color: primaryColor),
          const _JournalEntry(
            emoji: '😊',
            title: "I've done my work today",
            time: '9:52 PM',
            content: "I'm doing my part",
            tag: 'Work',
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          const SizedBox(height: 16),
          const _DateSection(
              date: 'NOV 14',
              day: 'Yesterday',
              weekday: 'Tuesday',
              color: primaryColor),
          const _JournalEntry(
            emoji: '😊',
            title: "I've done Jogging",
            time: '9:52 PM',
            content: "I'm doing 1 mile jogging with friends",
            tag: 'Exercise',
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'October',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const _DateSection(
              date: 'NOV 14',
              day: 'Yesterday',
              weekday: 'Tuesday',
              color: primaryColor),
          const _JournalEntry(
            emoji: '😊',
            title: "I've done Jogging",
            time: '9:52 PM',
            content: "I'm doing 1 mile jogging with friends",
            tag: 'Exercise',
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTab() {
    return Container(
      color: Colors.white, // Set the background color of the bottom tab
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .center, // Center the "Create note" button horizontally
        children: [
          Material(
            color: Colors
                .transparent, // Ensure no visible background color for the material
            child: InkWell(
              borderRadius: BorderRadius.circular(
                  24), // Rounded border for the ink effect area
              splashColor:
                  primaryColor.withOpacity(0.3), // Splash color when tapped
              highlightColor: Colors
                  .transparent, // No highlight color (no background change)
              onTap: () {
                // Add note creation logic here
                context.go('/journalCreateNote');
              },
              child: Container(
                width: 150, // Set a specific width for the button
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                // No background color here to keep it transparent
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                          8), // Adjust padding around the icon
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: primaryColor,
                            width: 2), // Border color for the icon
                      ),
                      child: const Icon(Icons.add,
                          color: primaryColor, size: 24), // Icon color and size
                    ),
                    const SizedBox(height: 4), // Space between icon and text
                    const Text(
                      'Create note',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  final String date;
  final String day;
  final String weekday;
  final Color color;

  const _DateSection({
    required this.date,
    required this.day,
    required this.weekday,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              weekday,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _JournalEntry extends StatelessWidget {
  final String emoji;
  final String title;
  final String time;
  final String content;
  final String tag;
  final Color primaryColor;
  final Color secondaryColor;

  const _JournalEntry({
    required this.emoji,
    required this.title,
    required this.time,
    required this.content,
    required this.tag,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(time, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: primaryColor),
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash, color: secondaryColor),
                onPressed: () {
                  // Add delete logic here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
