import 'package:flutter/material.dart';

class JournalCreateNote extends StatefulWidget {
  const JournalCreateNote({super.key});

  @override
  State<JournalCreateNote> createState() => _JournalCreateNoteState();
}

class _JournalCreateNoteState extends State<JournalCreateNote> {
  static const Color primaryColor = Color(0xFF5B50A0);
  static const Color secondaryColor = Color(0xFFFF0000);
  int selectedEmotion = -1;
  final List<bool> selectedReasons = List.generate(14, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: primaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("How’s your day?"),
          const SizedBox(height: 16),
          _buildEmotionGrid(),
          const SizedBox(height: 35),
          _buildTitle("What made your day?", fontSize: 24),
          const SizedBox(height: 35),
          _buildReasonWrap(),
          const SizedBox(height: 70),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildTitle(String text, {double fontSize = 34}) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildEmotionGrid() {
    return GridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      children: [
        _emotionButton(0, 'Awesome', 'lib/assets/images/Journal/Awsome.png'),
        _emotionButton(1, 'Happy', 'lib/assets/images/Journal/Happy.png'),
        _emotionButton(2, 'Lovely', 'lib/assets/images/Journal/Inlove.png'),
        _emotionButton(3, 'Blessed', 'lib/assets/images/Journal/Angel.png'),
        _emotionButton(4, 'Okay', 'lib/assets/images/Journal/Calm.png'),
        _emotionButton(5, 'Sad', 'lib/assets/images/Journal/Sad.png'),
        _emotionButton(
            6, 'Terrible', 'lib/assets/images/Journal/Disappointed.png'),
        _emotionButton(7, 'Angry', 'lib/assets/images/Journal/Angry.png'),
      ],
    );
  }

  Widget _emotionButton(int index, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmotion = index;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: selectedEmotion == index
                ? primaryColor.withOpacity(0.4)
                : primaryColor.withOpacity(0.1),
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: selectedEmotion == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonWrap() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _reasonButton(0, "Work"),
        _reasonButton(1, "Exercise"),
        _reasonButton(2, "Family"),
        _reasonButton(3, "Hobbies"),
        _reasonButton(4, "Finances"),
        _reasonButton(5, "Drink"),
        _reasonButton(6, "Food"),
        _reasonButton(7, "Relationships"),
        _reasonButton(8, "Music"),
        _reasonButton(9, "Education"),
        _reasonButton(10, "Travel"),
        _reasonButton(11, "Health"),
        _reasonButton(12, "Travel"),
        _reasonButton(13, "Weather"),
      ],
    );
  }

  Widget _reasonButton(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReasons[index] = !selectedReasons[index];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedReasons[index] ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectedReasons[index] ? Colors.white : primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        ),
        onPressed: () {
          // Handle continue button press
        },
        child: const Text(
          "CONTINUE",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
