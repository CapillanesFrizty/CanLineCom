import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Todo: Returns none because -1 is the default value
  int selectedEmotion = -1;

  final List<bool> selectedReasons = List.generate(14, (_) => false);

  // Text controllers for the form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isLoading = true;
  final supabase = Supabase.instance.client;
  User? _user;
  List<dynamic> journalEntries = [];

  // Add a GlobalKey for the Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitJournalEntry() async {
    // First, validate the form fields
    if (!_formKey.currentState!.validate()) {
      // If form fields are invalid, do not proceed
      return;
    }

    // Then, validate the emotion selection
    if (selectedEmotion == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an emotion.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // If all validations pass, proceed with submission
    setState(() {
      isLoading = true;
    });

    final String emotion = [
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
      'title_of_the_journal': _titleController.text.trim(),
      'body_of_journal': _contentController.text.trim(),
      'emotion': emotion,
      'created_by': _user!.id,
    };

    try {
      // Insert data into the "Journal" table
      await supabase.from('Journal').insert([journalEntry]).select();

      // Show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry submitted successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Update the journal entries
      fetchUserJournalEntries();
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error occurred: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
        _titleController.clear();
        _contentController.clear();
        selectedEmotion = -1;
      });
    }
  }

  // Function for fetching journal entries
  Future<void> fetchUserJournalEntries() async {
    // Fetch data from the "Journal" table with the User's ID
    final u = await supabase.auth.getUser();

    setState(() {
      _user = u.user;
    });

    final response = await supabase
        .from('Journal')
        .select()
        .eq('created_by', _user!.id)
        .order("created_at", ascending: false);

    debugPrint('Journal Entries: $response');

    setState(() {
      journalEntries = response as List<dynamic>;
      isLoading = false;
    });
  }

  // Function for deleting journal entries
  Future<void> deleteJournalEntry(int id) async {
    try {
      // Delete data from the "Journal" table with the specified ID
      final response =
          await supabase.from('Journal').delete().eq('journal_id', id);

      if (response != null) {
        debugPrint('Journal Entry Deleted: $response');

        // Update UI by removing the deleted entry
        setState(() {
          journalEntries.removeWhere((entry) => entry['journal_id'] == id);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry deleted successfully!'),
          backgroundColor: const Color.fromARGB(255, 255, 27, 27),
          duration: const Duration(seconds: 2),
        ),
      );
      fetchUserJournalEntries();
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error deleting journal entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting journal entry: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
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
          _buildBottomSheet();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _buildBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true, // Allows resizing when the keyboard opens
      context: context,
      builder: (BuildContext context) {
        int localSelectedEmotion = selectedEmotion;

        return StatefulBuilder(
          builder: (context, setModalState) {
            // Function to update the selected index
            void changeIndex(int index) {
              setModalState(() {
                localSelectedEmotion = index;
              });
              setState(() {
                selectedEmotion = index;
              });
            }

            // Radio button builder
            Widget buildCustomRadio({
              required String imagePath,
              required String label,
              required int index,
            }) =>
                GestureDetector(
                  onTap: () {
                    changeIndex(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        minRadius: 2.0,
                        backgroundColor: (localSelectedEmotion == index)
                            ? primaryColor.withOpacity(0.1)
                            : primaryColor.withOpacity(0.5),
                        child: Image.asset(
                          imagePath,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Text(
                        label,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: (localSelectedEmotion == index)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );

            return DraggableScrollableSheet(
              initialChildSize: 0.8, // Start at 80% of screen height
              minChildSize: 0.5, // Minimum height is 50% of screen
              maxChildSize: 1.0, // Can expand to full screen
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
                    ), // Adjust padding for the keyboard
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            border: Border.all(color: Colors.yellow[700]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.yellow[700],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Kindly fill out all required fields(*).',
                                  style: GoogleFonts.poppins(
                                    color: Colors.yellow[700],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'How are you feeling today?*',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              buildCustomRadio(
                                index: 0,
                                label: 'Awesome',
                                imagePath:
                                    'lib/assets/images/Journal/Awsome.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 1,
                                label: 'Happy',
                                imagePath:
                                    'lib/assets/images/Journal/Happy.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 2,
                                label: 'Lovely',
                                imagePath:
                                    'lib/assets/images/Journal/Inlove.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 3,
                                label: 'Blessed',
                                imagePath:
                                    'lib/assets/images/Journal/Angel.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 4,
                                label: 'Okay',
                                imagePath: 'lib/assets/images/Journal/Calm.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 5,
                                label: 'Sad',
                                imagePath: 'lib/assets/images/Journal/Sad.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 6,
                                label: 'Terrible',
                                imagePath:
                                    'lib/assets/images/Journal/Disappointed.png',
                              ),
                              const SizedBox(width: 10),
                              buildCustomRadio(
                                index: 7,
                                label: 'Angry',
                                imagePath:
                                    'lib/assets/images/Journal/Angry.png',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey, // Assign the GlobalKey here
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title of your Journal*',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter the title of the journal.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _contentController,
                                decoration: const InputDecoration(
                                  labelText: 'Share your thoughts here...*',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignLabelWithHint: true,
                                ),
                                maxLines: 10,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter the content of the journal.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(double.infinity, 50),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              _submitJournalEntry();
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (journalEntries.isEmpty) {
      return const Center(
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
          const SizedBox(height: 20),

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

  // todo: update the Function to get emoji for emotion
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Note"),
                      contentPadding: const EdgeInsets.all(20),
                      content: Text("Are you sure to delete this Journal?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: onDelete,
                          child: Text("Yes"),
                        ),
                      ],
                    ),
                  );
                }, // Call the delete callback
              ),
            ],
          ),
        ],
      ),
    );
  }
}
