import 'package:flutter/material.dart';

class SearchBarInfoHub extends StatelessWidget {
  const SearchBarInfoHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Color(0xFF5B50A0)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF5B50A0)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF5B50A0), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF5B50A0), width: 2.0),
          ),
        ),
      ),
    );
  }
}