import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchWidget({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
