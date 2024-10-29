import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      children: [
        _buildGreetingText(),
        _buildSearchField(),
        _buildGridView(context),
      ],
    );
  }

  Widget _buildGreetingText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 100, 30, 30),
      child: Text(
        "Hello\nHanna Forger!",
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5B50A0),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffF3EBFF),
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: Color(0xff5B50A0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xffF3EBFF), width: 1.0), // Border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
                color: Color(0xff5B50A0), width: 1.5), // Border when focused
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Color(0xff5B50A0), fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1 / 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _buildGridItems(context),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    return [
      _buildGridItem(
        label: "Health\nInstitution",
        iconAsset: 'lib/assets/icons/Hospital.svg',
        textColor: 0xffff5267,
        bgColor: 0xffffd7db,
        iconColor: 0xffff5267,
        onTap: () => context.go('/Health-Insititution'),
      ),
      _buildGridItem(
        label: "Financial\nSupport",
        iconAsset: 'lib/assets/icons/Financial.svg',
        textColor: 0xff3cc34f,
        bgColor: 0xffcbffd2,
        iconColor: 0xff3cc34f,
        onTap: () {
          context.go('/Financial-Institution');
        },
      ),
      _buildGridItem(
        label: "Blogs/News",
        iconAsset: 'lib/assets/icons/Blogs.svg',
        textColor: 0xffffa133,
        bgColor: 0xffffead1,
        iconColor: 0xffffa133,
        onTap: () => context.go('/Blog'),
      ),
      _buildGridItem(
        label: "Clinics\n(External)",
        iconAsset: 'lib/assets/icons/Clinics.svg',
        textColor: 0xff3f52ff,
        bgColor: 0xffd9ddff,
        iconColor: 0xff3f52ff,
        onTap: () => context.go('/clinic'),
      ),
    ];
  }

  Widget _buildGridItem({
    required String label,
    required String iconAsset,
    required int textColor,
    required int bgColor,
    required int iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(bgColor),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 25% opacity
              blurRadius: 4, // Softness of the shadow
              offset: Offset(0, 4), // Position of the shadow (y=4)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displaying the icon (using SvgPicture for SVG assets)
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
