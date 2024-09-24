import 'package:flutter/material.dart';
import '../../Layouts/GridViewLayout/GridViewLayout.dart';
import '../../widgets/BarrelFileWidget..dart';
import 'package:go_router/go_router.dart';

class Clinicsscreen extends StatelessWidget {
  const Clinicsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            "Clinics",
            style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridLayout(
              childrenProps: List.generate(6, (index) {
                return CardDesign1(
                  goto: () {
                    // Handle navigation when a card is tapped
                    print("Navigate to clinic details for card $index");
                  },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
