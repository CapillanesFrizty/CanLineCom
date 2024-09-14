import 'package:flutter/material.dart';

class ScaffoldLayoutWidget extends StatefulWidget {
  final Widget bodyWidget;
  final List<Widget> actionsWidget;

  const ScaffoldLayoutWidget(
      {super.key, required this.bodyWidget, required this.actionsWidget});

  @override
  State<ScaffoldLayoutWidget> createState() => _ScaffoldLayoutWidgetState();
}

class _ScaffoldLayoutWidgetState extends State<ScaffoldLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: widget.actionsWidget,
      ),
      body: widget.bodyWidget,
    );
  }
}
