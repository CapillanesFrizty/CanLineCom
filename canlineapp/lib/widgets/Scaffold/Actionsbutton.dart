import 'package:flutter/material.dart';

class ActionsButtons extends StatelessWidget {
  final Widget icon;
  const ActionsButtons({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Removes default padding
        ),
        child: icon,
      ),
    );
  }
}
