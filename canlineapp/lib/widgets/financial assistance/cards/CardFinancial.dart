 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardFinancial extends StatelessWidget {
  final VoidCallback onTap;

  const CardFinancial({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFCBFFD2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                'lib/assets/icons/Financial.svg', 
                color: const Color(0xFF3CC34F),
                width: 69.0,
                height: 62.0,
              ),
            const SizedBox(height: 20.0),
              const Text(
                'Financial',
                style: TextStyle(fontFamily: 'GilroyLight', fontWeight: FontWeight.bold, color: Color(0xFF3CC34F), fontSize: 14.0),
              ),
              const Text(
                'Institutions',
                style: TextStyle(fontFamily: 'GilroyLight', fontWeight: FontWeight.bold, color: Color(0xFF3CC34F), fontSize: 14.0),
              ),
          ],
        ),
      ),
    );
  }
}