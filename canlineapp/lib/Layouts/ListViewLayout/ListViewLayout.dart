import 'package:flutter/material.dart';

class Listviewlayout extends StatelessWidget {
  final List<Widget> children;
  const Listviewlayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: children,
    );
  }
}
