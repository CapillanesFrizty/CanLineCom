import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final double? elevation;

  const ScaffoldLayoutWidget({
    super.key,
    required this.bodyWidget,
    this.actionsWidget,
    this.leadingWidget,
    this.titleWidget,
    this.elevation,
  });

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  int _currentIndex = 0;

  static const Color _primaryColor = Color(0xFF5B50A0);
  static const double _iconSize = 28.0;
  static const double _toolbarHeight = 80.0;

  static const List<String> _routes = [
    '/',
    '/journal',
    '/events',
    '/profile',
  ];

  static const List<({IconData outlined, IconData filled})> _icons = [
    (outlined: Icons.home_max_outlined, filled: Icons.home_rounded),
    (outlined: Icons.menu_book, filled: Icons.menu_book_sharp),
    (outlined: Icons.event, filled: Icons.event),
    (outlined: Icons.person_outline, filled: Icons.person),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  BottomNavigationBarItem _buildNavItem(int index, {bool isCenter = false}) {
    Widget buildIcon(IconData icon) {
      if (isCenter) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(icon),
      );
    }

    return BottomNavigationBarItem(
      icon: buildIcon(_icons[index].outlined),
      activeIcon: buildIcon(_icons[index].filled),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: widget.elevation ?? 0,
        backgroundColor: Colors.white,
        toolbarHeight: _toolbarHeight,
        title: widget.titleWidget,
        actions: widget.actionsWidget,
        leadingWidth: 65,
        leading: widget.leadingWidget != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: widget.leadingWidget!,
              )
            : null,
      ),
      body: widget.bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _primaryColor.withOpacity(0.55),
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: _iconSize,
        items: List.generate(
          _icons.length,
          (index) => _buildNavItem(
            index,
            isCenter: index == 0,
          ),
        ),
      ),
    );
  }
}
