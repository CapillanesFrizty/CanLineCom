import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../../screen/BarrelFileScreen.dart';

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
  int _currentIndex = 0;

  final List<String> _routes = [
    '/', // Home route
    '/favorites',
  ];

  @override
  Widget build(BuildContext context) {
    // Determine the current location
    String currentLocation;

    currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    // Map the current location to the corresponding index
    if (_routes.contains(currentLocation)) {
      _currentIndex = _routes.indexOf(currentLocation);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: widget.elevation,
        backgroundColor: Colors.white,
        actions: widget.actionsWidget,
        leading: widget.leadingWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30, color: Colors.purple),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline, size: 30, color: Colors.purple),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.smart_toy_outlined, size: 30, color: Colors.purple),
            label: 'Smart Toy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined,
                size: 30, color: Colors.purple),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30, color: Colors.purple),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the selected route using GoRouter
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/favorites');
              break;
            default:
              break;
          }
        },
      ),
      body: widget.bodyWidget,
    );
  }
}
