import 'package:cancerline_companion/Presentation/screen/Journal/journalanalytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color primaryColor = Color(0xFF5B50A0);
  static const Color secondaryColor = Color(0xFFFF0000);

  int selectedEmotion = -1;
  String? selectedFilterEmotion;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedSortOption;

  final List<bool> selectedReasons = List.generate(14, (_) => false);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isLoading = true;
  final supabase = Supabase.instance.client;
  List<dynamic> journalEntries = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUserJournalEntries();
  }

  Future<void> _submitJournalEntry() async {
    if (!_formKey.currentState!.validate()) return;
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

    setState(() => isLoading = true);

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

    final currentUser = supabase.auth.currentUser;
    final Map<String, dynamic> journalEntry = {
      'title_of_the_journal': _titleController.text.trim(),
      'body_of_journal': _contentController.text.trim(),
      'emotion': emotion,
      'created_by': currentUser!.id,
    };

    try {
      await supabase.from('Journal').insert([journalEntry]).select();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal entry submitted successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      fetchUserJournalEntries();
    } catch (e) {
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

  Future<void> fetchUserJournalEntries() async {
    final u = supabase.auth.currentSession;

    final response = await supabase
        .from('Journal')
        .select()
        .eq('created_by', u!.user.id)
        .order("created_at", ascending: false);

    debugPrint('Journal Entries: $response');

    if (mounted) {
      setState(() {
        journalEntries = response as List<dynamic>;
        isLoading = false;
      });
    }
  }

  Future<void> deleteJournalEntry(int id) async {
    try {
      final response =
          await supabase.from('Journal').delete().eq('journal_id', id);

      if (response != null) {
        debugPrint('Journal Entry Deleted: $response');
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
    } catch (e) {
      debugPrint('Error deleting journal entry: $e');
      // Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting journal entry: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Ensure the background is transparent
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _buildDrawerContent(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDrawerContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Filter Journals',
            style: TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your view',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.calendar, color: primaryColor),
                  title: Text(
                    'Select Date Range',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Filter entries by date',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'Start',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: selectedStartDate != null
                              ? Text(
                                  DateFormat('MM/dd/yyyy')
                                      .format(selectedStartDate!),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  'Select date',
                                  style: TextStyle(color: Colors.grey),
                                ),
                          onTap: () async {
                            final DateTime? result = await showDatePicker(
                              context: context,
                              initialDate: selectedStartDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: selectedEndDate ?? DateTime(2101),
                            );
                            if (result != null) {
                              setState(() {
                                selectedStartDate = result;
                                Navigator.pop(context);
                                _showFilterDrawer(); // Reopen drawer to show updated dates
                              });
                            }
                          },
                        ),
                      ),
                      Icon(LucideIcons.arrowRight,
                          size: 16, color: Colors.grey),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'End',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: selectedEndDate != null
                              ? Text(
                                  DateFormat('MM/dd/yyyy')
                                      .format(selectedEndDate!),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  'Select date',
                                  style: TextStyle(color: Colors.grey),
                                ),
                          onTap: () async {
                            if (selectedStartDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Please select a start date first'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final DateTime? result = await showDatePicker(
                              context: context,
                              initialDate:
                                  selectedEndDate ?? selectedStartDate!,
                              firstDate: selectedStartDate!,
                              lastDate: DateTime(2101),
                            );
                            if (result != null) {
                              setState(() {
                                selectedEndDate = result;
                                Navigator.pop(context);
                                _showFilterDrawer(); // Reopen drawer to show updated dates
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ExpansionTile(
              leading: Icon(LucideIcons.smile, color: primaryColor),
              title: Text(
                'Filter by Emotion',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('See entries with specific emotions'),
              children: [
                ...[
                  'Awesome',
                  'Happy',
                  'Lovely',
                  'Blessed',
                  'Okay',
                  'Sad',
                  'Terrible',
                  'Angry'
                ].map((String value) {
                  return ListTile(
                    leading: Text(_getEmojiForEmotion(value)),
                    title: Text(
                      value,
                      style: TextStyle(color: primaryColor),
                    ),
                    selected: selectedFilterEmotion == value,
                    selectedColor: primaryColor,
                    selectedTileColor: primaryColor.withOpacity(0.1),
                    onTap: () {
                      setState(() => selectedFilterEmotion = value);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ExpansionTile(
              leading: Icon(LucideIcons.arrowUpDown, color: primaryColor),
              title: Text(
                'Sort Entries',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('Change the order of entries'),
              children: [
                ListTile(
                  leading: Icon(LucideIcons.arrowUp),
                  title: Text('Newest First'),
                  selected: selectedSortOption == 'newest',
                  selectedColor: primaryColor,
                  selectedTileColor: primaryColor.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      selectedSortOption = 'newest';
                      journalEntries.sort(
                          (a, b) => b['created_at'].compareTo(a['created_at']));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(LucideIcons.arrowDown),
                  title: Text('Oldest First'),
                  selected: selectedSortOption == 'oldest',
                  selectedColor: primaryColor,
                  selectedTileColor: primaryColor.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      selectedSortOption = 'oldest';
                      journalEntries.sort(
                          (a, b) => a['created_at'].compareTo(b['created_at']));
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isButtonsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isButtonsVisible) ...[
            FloatingActionButton(
              heroTag: "filter",
              onPressed: _showFilterDrawer,
              backgroundColor: primaryColor,
              child: const Icon(LucideIcons.filter, color: Colors.white),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              heroTag: "analytics",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AnalyticsJournal()),
                );
              },
              backgroundColor: primaryColor,
              child: const Icon(LucideIcons.lineChart, color: Colors.white),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              heroTag: "add",
              onPressed: _buildBottomSheet,
              backgroundColor: primaryColor,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            SizedBox(height: 16),
          ],
          FloatingActionButton(
            heroTag: "toggle",
            onPressed: () {
              setState(() {
                _isButtonsVisible = !_isButtonsVisible;
              });
            },
            backgroundColor: primaryColor,
            child: Icon(
              _isButtonsVisible ? Icons.close : Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (journalEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.book,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No journal entries yet",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start writing your thoughts!",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    List<dynamic> filteredEntries = journalEntries;

    // Filter by emotion
    if (selectedFilterEmotion != null) {
      filteredEntries = filteredEntries
          .where((entry) => entry['emotion'] == selectedFilterEmotion)
          .toList();
    }

    // Filter by date range
    if (selectedStartDate != null && selectedEndDate != null) {
      filteredEntries = filteredEntries.where((entry) {
        DateTime entryDate = DateTime.parse(entry['created_at']);
        return entryDate.isAfter(selectedStartDate!) &&
            entryDate.isBefore(selectedEndDate!.add(Duration(days: 1)));
      }).toList();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedFilterEmotion != null ||
              selectedStartDate != null ||
              selectedEndDate != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Active Filters: ',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (selectedFilterEmotion != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          avatar:
                              Text(_getEmojiForEmotion(selectedFilterEmotion!)),
                          label: Text(selectedFilterEmotion!),
                          onDeleted: () {
                            setState(() => selectedFilterEmotion = null);
                          },
                          backgroundColor: primaryColor.withOpacity(0.1),
                          deleteIconColor: primaryColor,
                        ),
                      ),
                    if (selectedStartDate != null && selectedEndDate != null)
                      Chip(
                        avatar: Icon(LucideIcons.calendar,
                            size: 16, color: primaryColor),
                        label: Text(
                          '${DateFormat('MM/dd').format(selectedStartDate!)} - ${DateFormat('MM/dd').format(selectedEndDate!)}',
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedStartDate = null;
                            selectedEndDate = null;
                          });
                        },
                        backgroundColor: primaryColor.withOpacity(0.1),
                        deleteIconColor: primaryColor,
                      ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = filteredEntries[index];
                return _JournalEntry(
                  emoji: _getEmojiForEmotion(entry['emotion']),
                  title: entry['title_of_the_journal'],
                  time: entry['created_at'],
                  content: entry['body_of_journal'],
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                  onDelete: () => deleteJournalEntry(entry['journal_id']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _buildBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.95,
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
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag indicator
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title
                          Text(
                            'Add New Journal Entry',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildWarningMessage(),
                          const SizedBox(height: 30),
                          // Emotions section
                          Text(
                            'How are you feeling today?*',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                final emotions = [
                                  (
                                    'Awesome',
                                    'lib/assets/images/Journal/Awsome.png'
                                  ),
                                  (
                                    'Happy',
                                    'lib/assets/images/Journal/Happy.png'
                                  ),
                                  (
                                    'Lovely',
                                    'lib/assets/images/Journal/Inlove.png'
                                  ),
                                  (
                                    'Blessed',
                                    'lib/assets/images/Journal/Angel.png'
                                  ),
                                  (
                                    'Okay',
                                    'lib/assets/images/Journal/Calm.png'
                                  ),
                                  ('Sad', 'lib/assets/images/Journal/Sad.png'),
                                  (
                                    'Terrible',
                                    'lib/assets/images/Journal/Disappointed.png'
                                  ),
                                  (
                                    'Angry',
                                    'lib/assets/images/Journal/Angry.png'
                                  ),
                                ];

                                return Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedEmotion = index;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: selectedEmotion == index
                                            ? primaryColor.withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedEmotion == index
                                              ? primaryColor
                                              : Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            emotions[index].$2,
                                            width: 50,
                                            height: 50,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            emotions[index].$1,
                                            style: TextStyle(
                                              color: selectedEmotion == index
                                                  ? primaryColor
                                                  : Colors.grey[600],
                                              fontWeight:
                                                  selectedEmotion == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Form section
                          Text(
                            'Your Thoughts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildForm(),
                          const SizedBox(height: 30),
                          // Save button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: _submitJournalEntry,
                              child: const Text(
                                'Save Entry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWarningMessage() {
    return Container(
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
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title of your Journal*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
        return '🤔';
    }
  }

  Widget buildCustomRadio({
    required String imagePath,
    required String label,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedEmotion = index),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selectedEmotion == index
                ? primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selectedEmotion == index ? primaryColor : Colors.grey[200]!,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selectedEmotion == index
                      ? primaryColor
                      : Colors.grey[600],
                  fontWeight: selectedEmotion == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalEntry extends StatelessWidget {
  final String emoji;
  final String title;
  final String time;
  final String content;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onDelete;

  const _JournalEntry({
    required this.emoji,
    required this.title,
    required this.time,
    required this.content,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.1)),
      ),
      child: InkWell(
        // Add InkWell for tap feedback
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMMM dd, yyyy - hh:mm a')
                                        .format(DateTime.parse(time)),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: 500,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(LucideIcons.x, size: 18),
                              label: Text('Close'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete();
                              },
                              icon: Icon(LucideIcons.trash, size: 18),
                              label: Text('Delete'),
                              style: TextButton.styleFrom(
                                foregroundColor: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                        Text(
                          DateFormat('MMM dd, yyyy')
                              .format(DateTime.parse(time)),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(LucideIcons.trash,
                        color: secondaryColor, size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text("Delete Journal Entry?"),
                          content: Text("This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  {onDelete(), Navigator.of(context).pop()},
                              child: Text(
                                "Delete",
                                style: TextStyle(color: secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
