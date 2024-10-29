import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;
  final double? elevation;

  const ScaffoldLayoutWidget({
    super.key,
    required this.bodyWidget,
    this.actionsWidget,
    this.leadingWidget,
    this.elevation,
  });

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  int _currentIndex = 2; // Start with the Home tab selected
  final List<String> _routes = [
    '/search',
    '/favorites',
    '/',
    '/notifications',
    '/profile',
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    GoRouter.of(context).go(_routes[index]);
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon,
      {bool isCenter = false}) {
    return BottomNavigationBarItem(
      icon: isCenter
          ? Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Color(0xFF5B50A0)), // Home icon color
            )
          : Icon(icon),
      activeIcon: isCenter
          ? Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(activeIcon, color: Color(0xFF5B50A0)),
            )
          : Icon(activeIcon),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff5B50A0).withOpacity(
            0.6), // Make the BottomNavigationBar background transparent
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 28,
        items: [
          _buildNavItem(Icons.search_outlined, Icons.search),
          _buildNavItem(Icons.favorite_outline, Icons.favorite),
          _buildNavItem(Icons.home_max_outlined, Icons.home_rounded,
              isCenter: true), // Center item with circle background
          _buildNavItem(Icons.notifications_outlined, Icons.notifications),
          _buildNavItem(Icons.person_outline, Icons.person),
        ],
      ),
    );
  }
}
