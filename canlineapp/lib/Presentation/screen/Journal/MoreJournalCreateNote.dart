import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class MoreJournalCreateNote extends StatefulWidget {
  const MoreJournalCreateNote({super.key});

  @override
  State<MoreJournalCreateNote> createState() => _MoreJournalCreateNoteState();
  static const Color primaryColor = Color(0xFF5B50A0); // Custom primary color
}

class _MoreJournalCreateNoteState extends State<MoreJournalCreateNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _thoughtsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MoreJournalCreateNote.primaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDateTime(),
          const SizedBox(height: 30),
          _buildTitleTextField(),
          const SizedBox(height: 20),
          _buildThoughtsTextField(),
          const SizedBox(height: 30),
          _buildCompleteCheckInButton(),
        ],
      ),
    );
  }

  Widget _buildDateTime() {
    return Column(
      children: const [
        Text(
          'November',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MoreJournalCreateNote.primaryColor,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '9:45pm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MoreJournalCreateNote.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Title',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
      ),
    );
  }

  Widget _buildThoughtsTextField() {
    return TextField(
      controller: _thoughtsController,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: 'Share your thoughts here...',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MoreJournalCreateNote.primaryColor),
        ),
      ),
    );
  }

  Widget _buildCompleteCheckInButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle check-in completion
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MoreJournalCreateNote.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'COMPLETE CHECK-IN',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
