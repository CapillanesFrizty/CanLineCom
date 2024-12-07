import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final String? userid;
  const HomeScreen({super.key, this.userid});

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
      padding: const EdgeInsets.only(top: 20, bottom: 40),
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

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffF3EBFF),
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(Icons.search, color: Color(0xff5B50A0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xffF3EBFF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xff5B50A0), width: 1.5),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(color: Color(0xff5B50A0), fontSize: 14.0),
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
      children: _gridItems(userid),
    );
  }

  // Define grid items as a function
  List<Widget> _gridItems(String? userid) {
    return [
      _GridItem(
        label: "Health\nInstitution",
        iconAsset: 'lib/assets/icons/Hospital.svg',
        textColor: 0xffff5267,
        bgColor: 0xffffd7db,
        iconColor: 0xffff5267,
        route: '/Health-Institution',
      ),
      _GridItem(
        label: "Financial\nSupport",
        iconAsset: 'lib/assets/icons/Financial.svg',
        textColor: 0xff3cc34f,
        bgColor: 0xffcbffd2,
        iconColor: 0xff3cc34f,
        route: '/Financial-Institution',
      ),
      _GridItem(
        label: "Blogs/News",
        iconAsset: 'lib/assets/icons/Blogs.svg',
        textColor: 0xffffa133,
        bgColor: 0xffffead1,
        iconColor: 0xffffa133,
        route: '/Blog',
      ),
      _GridItem(
        label: "Oncologists",
        iconAsset: 'lib/assets/icons/Oncologists.svg',
        textColor: 0xff009999,
        bgColor: 0xffD1FFFF,
        iconColor: 0xff009999,
        route: '/Oncologists',
      ),
    ];
  }
}

// Separate widget for grid items
class _GridItem extends StatelessWidget {
  final String label;
  final String iconAsset;
  final int textColor;
  final int bgColor;
  final int iconColor;
  final String route;

  const _GridItem({
    required this.label,
    required this.iconAsset,
    required this.textColor,
    required this.bgColor,
    required this.iconColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        decoration: BoxDecoration(
          color: Color(bgColor),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
    );
  }
}
