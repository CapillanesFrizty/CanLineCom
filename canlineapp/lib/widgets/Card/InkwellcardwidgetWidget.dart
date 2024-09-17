import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Inkwellcardwidget extends StatelessWidget {
  final String label, iconAsset;
  final int textColor, bgColor, iconColor;
  final VoidCallback goto;

  const Inkwellcardwidget(
      {super.key,
      required this.label,
      required this.iconAsset,
      required this.textColor,
      required this.bgColor,
      required this.iconColor,
      required this.goto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Color(bgColor),
          borderRadius: BorderRadius.circular(20), // Circular border radius
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: goto,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  color: Color(iconColor),
                ),
                Text(
                  label,
                  style: TextStyle(color: Color(textColor)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}