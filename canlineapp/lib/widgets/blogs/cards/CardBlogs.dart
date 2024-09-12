import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CardBlogs extends StatelessWidget {
  final VoidCallback onTap;

  const CardBlogs({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFEAD1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                'lib/assets/icons/Clinics.svg', 
                color: const Color(0xFFFFA133),
                width: 69.0,
                height: 62.0,
              ),
            const SizedBox(height: 8.0),
            const Text(
              'Financial Assistance',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}