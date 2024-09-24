import 'package:flutter/material.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;
  final double? elevation;

  const ScaffoldLayoutWidget(
      {super.key,
      required this.bodyWidget,
      this.actionsWidget,
      this.leadingWidget,
      this.elevation});

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  // ignore: unused_field
  int _currentIndex = 0;

  void _updateState(int newState) {
    setState(() {
      _currentIndex = newState;
    });

    print("Current Index: $_currentIndex");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: widget.elevation,
        backgroundColor: Colors.white,
        actions: widget.actionsWidget,
        leading: widget.leadingWidget,
      ),
      bottomNavigationBar: buttomNavigationbar(_updateState),
      body: widget.bodyWidget,
    );
  }
}

// ! ButtonNavBar builder

Widget buttomNavigationbar(Function(int) updateState) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 20, // Adds space between FAB and BottomAppBar
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceAround, // Evenly space the icons
      children: [
        IconButton(
          icon: const Icon(Icons.home_outlined, size: 30),
          onPressed: () {
            updateState(0); // Call updateState with index 0
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_outline, size: 30),
          onPressed: () {
            updateState(1); // Call updateState with index 1
          },
        ),
        IconButton(
          onPressed: () => print("Bot is Clicked"),
          icon: Icon(Icons.smart_toy_outlined, size: 30),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 30),
          onPressed: () {
            updateState(2); // Call updateState with index 2
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, size: 30),
          onPressed: () {
            updateState(3); // Call updateState with index 3
          },
        ),
      ],
    ),
  );
}
