import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CardDesign1 extends StatefulWidget {
  final VoidCallback? goto;
  final String title;
  final String subtitle;
  final String image;
  final String location; // Add location
  final String address; // Add complete address
  final String distance; // Add distance information
  final String time;
  final String date;
  final String gender;

  const CardDesign1({
    super.key,
    this.goto,
    required this.title,
    required this.subtitle,
    required this.image,
    this.location = '', // Optional with default value
    this.address = '', // Optional with default value
    this.distance = '', // Optional with default value
    this.time = '', // Optional with default value
    this.date = '', // Optional with default value
    this.gender = '', // Optional with default value
  });

  @override
  State<CardDesign1> createState() => _CardDesign1State();
}

class _CardDesign1State extends State<CardDesign1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate dynamic image height based on screen width
    final imageHeight = screenWidth * 0.4; // 40% of screen width

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _controller,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.goto?.call();
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isPressed ? 0.05 : 0.08),
                      offset: Offset(0, _isPressed ? 1 : 2),
                      blurRadius: _isPressed ? 4 : 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9, // Standard aspect ratio
                        child: Stack(
                          children: [
                            widget.image.isNotEmpty
                                ? Hero(
                                    tag: 'healthcare-${widget.title}',
                                    child: Image.network(
                                      widget.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildPlaceholder(imageHeight),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return _buildLoadingIndicator(
                                            imageHeight);
                                      },
                                    ),
                                  )
                                : _buildPlaceholder(imageHeight),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getSubtitleColor(widget.subtitle),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2D2D2D),
                            ),
                          ),
                          if (widget.location.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (widget.distance.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.distance,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: widget.goto,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    minimumSize: Size.zero,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Details',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[100],
      child: Icon(
        Icons.image_outlined,
        size: height * 0.2, // Dynamic icon size
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildLoadingIndicator(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[100],
      child: Center(
        child: SizedBox(
          width: height * 0.15, // Dynamic loader size
          height: height * 0.15,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Color _getSubtitleColor(String secondaryText) {
    final text = secondaryText.toLowerCase();
    if (text.contains("government")) {
      return Colors.green[600]!;
    } else if (text.contains("private")) {
      return Colors.blue[600]!;
    }
    return const Color(0xff5B50A0);
  }
}
