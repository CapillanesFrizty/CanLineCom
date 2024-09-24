import 'package:go_router/go_router.dart';

import '../../widgets/BarrelFileWidget..dart';
import 'package:flutter/material.dart';
import '../../Layouts/BarrelFileLayouts.dart';

class HealthInstitutionScreen extends StatelessWidget {
  const HealthInstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Title(
                color: Color(0xFF000000),
                child: Text(
                  "Health\nInstitution",
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: SearchBar(
                autoFocus: false,
                leading: Icon(Icons.search),
                hintText: "Search",
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 20.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Government Hospital'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text('Private Hospital'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                height: 400, // Set a fixed height or use shrinkWrap
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1.2,
                  shrinkWrap: true, // Shrink the GridView to fit its content
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  children: [
                    CardDesign1(goto: () {
                      context.go('/Health-Insititution/More-Info');
                    }),
                    const CardDesign1(),
                    const CardDesign1(),
                    const CardDesign1(),
                    const CardDesign1(),
                    const CardDesign1(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
