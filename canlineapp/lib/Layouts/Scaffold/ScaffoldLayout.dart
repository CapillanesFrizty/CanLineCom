import 'package:flutter/material.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;

  const ScaffoldLayoutWidget(
      {super.key,
      required this.bodyWidget,
      this.actionsWidget,
      this.leadingWidget});

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  int _currentIndex = 0;

  void _updateState(int newState) {
    setState(() {
      _currentIndex = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: widget.actionsWidget,
        leading: widget.leadingWidget,
      ),
      bottomNavigationBar: buttomNavigationbar(_currentIndex, _updateState),
      body: widget.bodyWidget,
    );
  }
}

// ! ButtonNavBar builder

Widget buttomNavigationbar(int currentIndex, Function(int) updatestate) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (value) {
      // Respond to item press.
      updatestate(value);
      print(value);
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  );
}
