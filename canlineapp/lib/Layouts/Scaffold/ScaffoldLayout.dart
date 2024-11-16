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
    this.leadingWidget,
    this.titleWidget,
    this.elevation,
    this.userid,
  });

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  int _currentIndex = 0;

  static const Color _primaryColor = Color(0xFF5B50A0);
  static const double _iconSize = 28.0;
  static const double _toolbarHeight = 40.0;

  late final List<String> _routes;

  @override
  void initState() {
    super.initState();
    _routes = [
      '/homescreen/${widget.userid}',
      '/homescreen/${widget.userid}/journal',
      '/homescreen/${widget.userid}/events',
      '/homescreen/${widget.userid}/profile',
    ];
  }

  static const List<({IconData outlined, IconData filled, String label})>
      _icons = [
    (outlined: Icons.home_outlined, filled: Icons.home, label: "Home"),
    (
      outlined: Icons.menu_book_outlined,
      filled: Icons.menu_book,
      label: "Journal"
    ),
    (outlined: Icons.event_outlined, filled: Icons.event, label: "Event"),
    (outlined: Icons.person_outline, filled: Icons.person, label: "Profile"),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _primaryColor,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          iconSize: _iconSize,
          items: _icons
              .map(
                (iconData) => BottomNavigationBarItem(
                  icon: Icon(iconData.outlined),
                  activeIcon: Icon(iconData.filled),
                  label: iconData.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
