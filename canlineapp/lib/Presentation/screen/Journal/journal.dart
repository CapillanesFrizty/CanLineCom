import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color primaryColor = Color(0xFF5B50A0);
  static const Color secondaryColor = Color(0xFFFF0000);
  int selectedEmotion = -1;
  final List<bool> selectedReasons = List.generate(14, (_) => false);

  // Text controllers for the form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Function to handle the submission of data
  void _submitJournalEntry() {
    // Collect data from fields
    final String title = titleController.text.trim();
    final String content = contentController.text.trim();
    final String emotion = selectedEmotion == -1
        ? "None"
        : [
            "Awesome",
            "Happy",
            "Lovely",
            "Blessed",
            "Okay",
            "Sad",
            "Terrible",
            "Angry"
          ][selectedEmotion];

    // Print the submitted data
    print("Submitted Journal Entry:");
    print("Emotion: $emotion");
    print("Title: $title");
    print("Content: $content");

    // Optionally clear the fields after submission
    titleController.clear();
    contentController.clear();
    setState(() {
      selectedEmotion = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Journal Entry'),
                      const SizedBox(height: 32),
                      const Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          itemExtent: 100,
                          children: [
                            _emotionButton(0, 'Awesome',
                                'lib/assets/images/Journal/Awsome.png'),
                            _emotionButton(1, 'Happy',
                                'lib/assets/images/Journal/Happy.png'),
                            _emotionButton(2, 'Lovely',
                                'lib/assets/images/Journal/Inlove.png'),
                            _emotionButton(3, 'Blessed',
                                'lib/assets/images/Journal/Angel.png'),
                            _emotionButton(4, 'Okay',
                                'lib/assets/images/Journal/Calm.png'),
                            _emotionButton(
                                5, 'Sad', 'lib/assets/images/Journal/Sad.png'),
                            _emotionButton(6, 'Terrible',
                                'lib/assets/images/Journal/Disappointed.png'),
                            _emotionButton(7, 'Angry',
                                'lib/assets/images/Journal/Angry.png'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                  labelText: 'Title of your Journal',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: contentController,
                              decoration: const InputDecoration(
                                labelText: 'Share you thoughts here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                alignLabelWithHint: true,
                              ),
                              maxLines: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: _submitJournalEntry,
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        children: const [
          _DateSection(
              date: 'NOV 13',
              day: 'Today',
              weekday: 'Wednesday',
              color: primaryColor),
          _JournalEntry(
            emoji: '😊',
            title: "I've done my work today",
            time: '9:52 PM',
            content: "I'm doing my part",
            tag: 'Work',
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _emotionButton(int index, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmotion = index;
          debugPrint('Selected emotion index: $index'); // Debugging statement
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
