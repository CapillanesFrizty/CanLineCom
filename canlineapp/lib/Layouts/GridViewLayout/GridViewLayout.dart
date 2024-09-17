import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final List<Widget> childrenPorps;
  const GridLayout({super.key, required this.childrenPorps});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      children: childrenPorps,
    );
  }
}
