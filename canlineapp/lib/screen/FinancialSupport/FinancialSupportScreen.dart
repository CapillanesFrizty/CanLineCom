import 'package:flutter/material.dart';

import '../../Layouts/BarrelFileLayouts.dart';
import '../../widgets/BarrelFileWidget..dart';

class FinancialSupportScreen extends StatelessWidget {
  const FinancialSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: const Listviewlayout(
        childrenProps: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Financial Support",
              style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: SearchBar(
              autoFocus: false,
              leading: Icon(Icons.search),
              hintText: "Search",
              padding: MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 20.0),
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
        ],
      ),
    );
  }
}
