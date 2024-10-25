import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/BarrelFileWidget..dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      children: [
        _buildGreetingText(),
        _buildSearchField(),
        _buildViewToggleButtons(),
        _buildGridView(context),
      ],
    );
  }

  Widget _buildGreetingText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child: Text(
        "Hello\nHanna Forge",
        style: TextStyle(
          fontFamily: "Gilroy-Medium",
          fontSize: 36.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5B50A0),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
          hintStyle: TextStyle(
            fontFamily: "Gilroy-Medium",
            color: Colors.grey.shade500,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.grid_3x3_outlined),
        ),
        const SizedBox(width: 1),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.view_column_outlined),
        ),
      ],
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
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
          context.go('/Financial-Support');
          debugPrint("Navigated to Financial Support");
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
    return Inkwellcardwidget(
      label: label,
      iconAsset: iconAsset,
      textColor: textColor,
      bgColor: bgColor,
      iconColor: iconColor,
      goto: onTap,
    );
  }
}
