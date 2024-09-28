import 'package:flutter/material.dart';

class Listviewlayout extends StatelessWidget {
  final List<Widget> childrenProps;
  const Listviewlayout({super.key, required this.childrenProps});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: childrenProps,
    );
  }
}
