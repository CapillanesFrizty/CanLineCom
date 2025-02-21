import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget>? actionsWidget;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final double? elevation;
  final String? userid;
  final bool showNavBar; // Add this parameter

  const ScaffoldLayoutWidget({
    super.key,
    required this.bodyWidget,
    this.actionsWidget,
    this.leadingWidget = null,
    this.titleWidget,
    this.elevation,
    this.userid,
    this.showNavBar = true, // Default value is true
  });

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class NavigationItem {
  final String id;
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  String _currentId = 'home';
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _inactiveColor = Color(0xFFADAFC5);
  bool _isNavigating = false;

  late final List<NavigationItem> _navigationItems;

  @override
  void initState() {
    super.initState();
    _navigationItems = [
      NavigationItem(
        id: 'home',
        icon: Icons.home_rounded,
        label: "Home",
        route: '/HomeScreen/${widget.userid}',
      ),
      NavigationItem(
        id: 'journal',
        icon: Icons.menu_book_rounded,
        label: "Journal",
        route: '/HomeScreen/${widget.userid}/journal',
      ),
      NavigationItem(
        id: 'resources',
        icon: Icons.source_rounded,
        label: "Resources",
        route: '/HomeScreen/${widget.userid}/resources',
      ),
      NavigationItem(
        id: 'profile',
        icon: Icons.person_rounded,
        label: "Profile",
        route: '/HomeScreen/${widget.userid}/profile',
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCurrentRoute();
    });
  }

  void _syncCurrentRoute() {
    if (!mounted) return;

    final location = GoRouterState.of(context).uri.path;
    String newId;

    if (location.endsWith('/journal')) {
      newId = 'journal';
    } else if (location.endsWith('/resources')) {
      newId = 'resources';
    } else if (location.endsWith('/profile')) {
      newId = 'profile';
    } else if (location.contains('/HomeScreen/')) {
      newId = 'home';
    } else {
      return;
    }

    if (_currentId != newId) {
      setState(() => _currentId = newId);
    }
  }

  Future<void> _onItemTapped(NavigationItem item) async {
    if (!mounted || _currentId == item.id || _isNavigating) return;

    try {
      setState(() => _isNavigating = true);

      setState(() => _currentId = item.id);

      // Use go() instead of push() to replace the current route
      context.go(item.route);
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }

  Widget buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.map((item) {
              final isSelected = _currentId == item.id;
              return _buildNavItem(item, isSelected);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, bool isSelected) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(item),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? _primaryColor.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.1 : 1.0,
                  child: Icon(
                    item.icon,
                    color: isSelected ? _primaryColor : _inactiveColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? _primaryColor : _inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: IconButton(
        icon: const Icon(
          LucideIcons.userCircle,
          size: 30,
          color: _primaryColor,
        ),
        onPressed: () {
          final userId = widget.userid;
          if (userId != null) {
            context.push('/Settings');
          }
        },
      ),
    );
  }

  @override
  void didUpdateWidget(ScaffoldLayoutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userid != oldWidget.userid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncCurrentRoute();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: widget.elevation ?? 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: widget.titleWidget,
        actions: [
          if (widget.actionsWidget != null) ...widget.actionsWidget!,
          if (_currentId == 'home' ||
              _currentId == 'journal' ||
              _currentId == 'profile' ||
              _currentId == 'events')
            _buildSettingsButton(),
        ],
        leadingWidth: widget.leadingWidget != null ? 50 : 10,
        leading: widget.leadingWidget != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: widget.leadingWidget,
              )
            : Container(),
      ),
      body: widget.bodyWidget,
      bottomNavigationBar:
          widget.showNavBar ? buildBottomBar() : null, // Conditional navbar
    );
  }
}
