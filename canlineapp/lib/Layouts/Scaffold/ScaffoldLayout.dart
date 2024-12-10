import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final double? elevation;
  final String? userid;

  const ScaffoldLayoutWidget({
    super.key,
    required this.bodyWidget,
    this.actionsWidget,
    this.leadingWidget = null,
    this.titleWidget,
    this.elevation,
    this.userid,
  });

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  late int _currentIndex;

  static const Color _primaryColor = Color(0xFF5B50A0);
  static const double _iconSize = 28.0;

  late final List<String> _routes;

  @override
  void initState() {
    super.initState();

    // Define routes based on userID
    _routes = [
      '/HomeScreen/${widget.userid}', // Home
      '/HomeScreen/${widget.userid}/journal', // Journal
      '/HomeScreen/${widget.userid}/events', // Events
      '/HomeScreen/${widget.userid}/profile', // Profile
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndexFromRoute();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndexFromRoute();
  }

  void _updateIndexFromRoute() {
    final currentRoute =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    if (currentRoute == null) return; // Exit if route is null

    for (int i = 0; i < _routes.length; i++) {
      if (currentRoute == _routes[i] ||
          currentRoute.startsWith('${_routes[i]}/')) {
        if (_currentIndex != i) {
          setState(() {
            _currentIndex = i;
          });
        }
        return; // Stop once a match is found
      }
    }

    // If no match, reset index (non-navigation routes)
    setState(() {
      _currentIndex = -1;
    });
  }

  static const List<({IconData outlined, IconData filled, String label})>
      _icons = [
    (outlined: Icons.home_outlined, filled: Icons.home, label: "Home"),
    (
      outlined: Icons.menu_book_outlined,
      filled: Icons.menu_book,
      label: "Journal"
    ),
    (outlined: Icons.event_outlined, filled: Icons.event, label: "Events"),
    (outlined: Icons.person_outline, filled: Icons.person, label: "Profile"),
  ];

  void _onTabSelected(int index) {
    if (index >= 0 && index < _routes.length && _currentIndex != index) {
      setState(() {
        _currentIndex = index; // Update index immediately
      });
      context.go(_routes[index]); // Navigate to the selected route
    }
  }

  Widget buildCustomNavigationBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
          (index) {
            final isSelected = _currentIndex == index;
            final iconData = _icons[index];

            return GestureDetector(
              onTap: () {
                _onTabSelected(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? iconData.filled : iconData.outlined,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: _iconSize,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    iconData.label,
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    width: isSelected ? 40 : 0,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: widget.elevation ?? 0,
        backgroundColor: Colors.white,
        title: widget.titleWidget,
        actions: widget.actionsWidget,
        leadingWidth: widget.leadingWidget != null ? 50 : 10,
        leading: widget.leadingWidget != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: widget.leadingWidget,
              )
            : Container(), // Suppress the default back button
      ),
      body: widget.bodyWidget,
      bottomNavigationBar: buildCustomNavigationBar(),
    );
  }
}
