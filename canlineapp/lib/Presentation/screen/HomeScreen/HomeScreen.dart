import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  final String? userid;
  const HomeScreen({super.key, this.userid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Define the fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshContent() async {
    setState(() {}); // This triggers a rebuild of the widget
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkInternetConnection(),
        builder: (context, networkSnapshot) {
          if (networkSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (networkSnapshot.data == false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFF5B50A0).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.wifiOff,
                      size: 48,
                      color: Color(0xFF5B50A0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Internet Connection',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B50A0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check your connection and try again',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshContent,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ).copyWith(bottom: 30.0), // Added bottom margin
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              _buildGreetingText(context),
              Container(
                child: _buildGridView(),
              )
            ],
          );
        });
  }

  Widget _buildGreetingText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 60),
      child: Text(
        "Greetings Warrior!",
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.sizeOf(context).height * 0.05,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5B50A0),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1 / 1.2, // Adjusted the aspect ratio
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _gridItems(),
    );
  }

  List<Widget> _gridItems() {
    return [
      _AnimatedGridItem(
        userid: widget.userid,
        label: "Health\nInstitution",
        iconAsset: 'lib/assets/icons/Hospital.svg',
        textColor: 0xffFF5267,
        bgColor: 0xffFFD7DB,
        iconColor: 0xffFF5267,
        route: '/Health-Institution',
        controller: _controller,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
      _AnimatedGridItem(
        userid: widget.userid,
        label: "Financial\nSupport",
        iconAsset: 'lib/assets/icons/Financial.svg',
        textColor: 0xff3CC34F,
        bgColor: 0xffCBFFD2,
        iconColor: 0xff3CC34F,
        route: '/Financial-Institution',
        controller: _controller,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
      // _AnimatedGridItem(
      //   label: "Blogs/News",
      //   iconAsset: 'lib/assets/icons/Blogs.svg',
      //   textColor: 0xffFFA133,
      //   bgColor: 0xffFFEAD1,
      //   iconColor: 0xffFFA133,
      //   route: '/Blog',
      //   controller: _controller,
      //   fadeAnimation: _fadeAnimation,
      //   scaleAnimation: _scaleAnimation,
      // ),
      _AnimatedGridItem(
        userid: widget.userid,
        label: "Support Groups",
        iconAsset: 'lib/assets/icons/Supportgroups.svg',
        textColor: 0xffFFA133,
        bgColor: 0xffFFEAD1,
        iconColor: 0xffFFA133,
        route: '/Support-Groups',
        controller: _controller,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
      _AnimatedGridItem(
        userid: widget.userid,
        label: "Medical\nSpecialists",
        iconAsset: 'lib/assets/icons/Oncologists.svg',
        textColor: 0xff139E9E,
        bgColor: 0xffD1FFFF,
        iconColor: 0xff139E9E,
        route: '/Medical-Specialists',
        controller: _controller,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
    ];
  }
}

class _AnimatedGridItem extends StatelessWidget {
  final String label;
  final String iconAsset;
  final int textColor;
  final int bgColor;
  final int iconColor;
  final String route;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final AnimationController controller;
  final userid;

  const _AnimatedGridItem({
    required this.label,
    required this.userid,
    required this.iconAsset,
    required this.textColor,
    required this.bgColor,
    required this.iconColor,
    required this.route,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: InkWell(
              onTap: () {
                if (route == '/Health-Institution') {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 15,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Color(bgColor).withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.warning,
                                  color: Color(textColor),
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Notice to Public',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(textColor),
                                ),
                              ),
                              const SizedBox(height: 15),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'The Information provided here as of now is ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'limited for Chemotherapy only',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      GoRouter.of(context).push(
                                          '/Health-Institution',
                                          extra: {'userid': userid});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF5B50A0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Proceed',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // For other routes, pass the userid as extra data
                  GoRouter.of(context).push(route, extra: {'userid': userid});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(bgColor),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconAsset,
                        color: Color(iconColor),
                        width: 60.0,
                        height: 65.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(textColor),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
