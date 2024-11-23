import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color primaryColor = Color(0xFF5B50A0);
  static const Color secondaryColor = Color(0xFFFF0000);
  int selectedEmotion = 0;
  final List<bool> selectedReasons = List.generate(14, (_) => false);

  // Text controllers for the form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isLoading = true;
  final supabase = Supabase.instance.client;
  User? _user;
  List<dynamic> journalEntries = [];

  // Function to handle the submission of data
  Future<void> _submitJournalEntry() async {
    // Collect data from fields
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();
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

    final Map<String, dynamic> journalEntry = {
      'title_of_the_journal': title,
      'body_of_journal': content,
      'emotion': emotion,
      'created_by': _user!.id,
    };

    // Print the submitted data
    try {
      // Insert data into the "Journal" table
      final response = await supabase
          .from('Journal')
          .insert([journalEntry]) // Wrap data in a list
          .select();

      // Print the response
      debugPrint('Journal Entry Submitted: $response');
      fetchUserJournalEntries();
    } catch (e) {
      // Handle unexpected exceptions
      debugPrint('Unexpected error: $e');
    }

    // Optionally clear the fields after submission
    _titleController.clear();
    _contentController.clear();
    setState(() {
      selectedEmotion = 0;
    });
  }

//  Function for fetching journal entries
  Future<void> fetchUserJournalEntries() async {
    // Fetch data from the "Journal" table with the User's ID
    final u = await supabase.auth.getUser();

    setState(() {
      _user = u.user;
    });

    final response =
        await supabase.from('Journal').select().eq('created_by', _user!.id);

    debugPrint('Journal Entries: $response');

    setState(() {
      journalEntries = response as List<dynamic>;
      isLoading = false;
    });
  }

//  Function for deletion journal entries
  Future<void> deleteJournalEntry(int id) async {
    try {
      // Delete data from the "Journal" table with the specified ID
      final response =
          await supabase.from('Journal').delete().eq('journal_id', id);

      if (response != null) {
        debugPrint('Journal Entry Deleted: $response');

        // Update UI by removing the deleted entry
        setState(() {
          journalEntries.removeWhere((entry) => entry['id'] == id);
        });
      }
      fetchUserJournalEntries();
    } catch (e) {
      debugPrint('Error deleting journal entry: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserJournalEntries();
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
                      const SizedBox(height: 24),
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
                              controller: _titleController,
                              decoration: const InputDecoration(
                                  labelText: 'Title of your Journal',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _contentController,
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (journalEntries.isEmpty) {
      return Center(
        child: Text(
          "No journal entries yet. Start writing!",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: ListView(
        children: [
          // Optional: Date section (example for one entry)
          // _Header(
          //   date: 'NOV 13',
          //   day: 'Today',
          //   weekday: 'Wednesday',
          //   color: primaryColor,
          // ),
          SizedBox(height: 32),
          Text(
            "My Journal",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          // Render Journal Entries
          ...journalEntries.map((entry) {
            return _JournalEntry(
              emoji: _getEmojiForEmotion(entry['emotion']),
              title: entry['title_of_the_journal'],
              time: entry['created_at'],
              content: entry['body_of_journal'],
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              onDelete: () => deleteJournalEntry(entry['journal_id']),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getEmojiForEmotion(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'awesome':
        return '🤩';
      case 'happy':
        return '😊';
      case 'lovely':
        return '😍';
      case 'blessed':
        return '😇';
      case 'okay':
        return '😌';
      case 'sad':
        return '😢';
      case 'terrible':
        return '😞';
      case 'angry':
        return '😡';
      default:
        return '🤔'; // Default emoji for undefined emotions
    }
  }

  Widget _emotionButton(int index, String label, String imagePath) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: const CircleBorder(),
            side: BorderSide(
              color: (selectedEmotion == index)
                  ? primaryColor.withOpacity(1)
                  : primaryColor.withOpacity(0.5),
              width: 0,
            ),
          ),
          onPressed: () {
            setState(() {
              selectedEmotion = index;
              debugPrint(
                  'Selected emotion index: $index'); // Debugging statement
            });
          },
          child: CircleAvatar(
            backgroundColor: (selectedEmotion == index)
                ? primaryColor.withOpacity(1)
                : primaryColor.withOpacity(0.5),
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight:
                selectedEmotion == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String date;
  final String day;
  final String weekday;
  final Color color;

  const _Header({
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
  // final String tag;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onDelete; // Add this parameter

  const _JournalEntry({
    required this.emoji,
    required this.title,
    required this.time,
    required this.content,
    // required this.tag,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onDelete, // Make it required
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: primaryColor.withOpacity(0.5)),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Text(
              //     tag,
              //     style: TextStyle(color: primaryColor),
              //   ),
              // ),
              IconButton(
                icon: Icon(LucideIcons.trash, color: secondaryColor),
                onPressed: onDelete, // Call the delete callback
              ),
            ],
          ),
        ],
      ),
    );
  }
}
