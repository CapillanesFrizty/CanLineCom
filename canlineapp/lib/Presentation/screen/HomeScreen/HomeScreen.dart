import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildGreetingText(context),
        Container(
          child: _buildGridView(),
        )
      ],
    );
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
      childAspectRatio: 1 / 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _gridItems(),
    );
  }

  List<Widget> _gridItems() {
    return [
      _AnimatedGridItem(
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
      _AnimatedGridItem(
        label: "Blogs/News",
        iconAsset: 'lib/assets/icons/Blogs.svg',
        textColor: 0xffFFA133,
        bgColor: 0xffFFEAD1,
        iconColor: 0xffFFA133,
        route: '/Blog',
        controller: _controller,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
      _AnimatedGridItem(
        label: "Oncologists",
        iconAsset: 'lib/assets/icons/Oncologists.svg',
        textColor: 0xff139E9E,
        bgColor: 0xffD1FFFF,
        iconColor: 0xff139E9E,
        route: '/Oncologists',
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

  const _AnimatedGridItem({
    required this.label,
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
              onTap: () => context.go(route),
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
