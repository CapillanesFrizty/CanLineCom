import 'package:flutter/material.dart';

import '../../Layouts/BarrelFileLayouts.dart';
import '../../widgets/BarrelFileWidget..dart';

class FinancialSupportScreen extends StatelessWidget {
  const FinancialSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Listviewlayout(
        childrenProps: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Financial Support",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none),
                hintText: "Search",
                hintStyle:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Government Assistance",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
          Carddesign2Carousellist(),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Private Assistance",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
          Carddesign2Carousellist(),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
