import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardHospital extends StatelessWidget {
  final VoidCallback onTap;

  const CardHospital({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160.0,
        height: 185.0,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD7DB),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/icons/Hospital.svg', 
                color: const Color(0xFFFF5267),
                width: 69.0,
                height: 62.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Hospital',
                style: TextStyle(fontFamily: 'GilroyLight', fontWeight: FontWeight.bold, color: Color(0xFFFF5267), fontSize: 14.0),
              ),
              const Text(
                'Institutions',
                style: TextStyle(fontFamily: 'GilroyLight', fontWeight: FontWeight.bold, color: Color(0xFFFF5267), fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}