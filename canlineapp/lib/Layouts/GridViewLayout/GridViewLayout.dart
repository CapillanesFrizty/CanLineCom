import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final List<Widget> childrenProps;
  const GridLayout({super.key, required this.childrenProps});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      children: childrenProps,
    );
  }
}
