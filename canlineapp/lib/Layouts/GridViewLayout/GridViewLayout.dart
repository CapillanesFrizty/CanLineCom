import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final List<Widget> childrenProps;
  const GridLayout({super.key, required this.childrenProps});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Wrap GridView with Expanded
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(), // Disable scrolling
        childAspectRatio: 0.90,
        children: childrenProps,
      ),
    );
  }
}
