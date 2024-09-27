import 'package:go_router/go_router.dart';
import '../../widgets/BarrelFileWidget..dart';
import 'package:flutter/material.dart';

class HealthInstitutionScreen extends StatelessWidget {
  const HealthInstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Title(
                color: Color(0xFF000000),
                child: Text(
                  "Health Institution",
                  style: TextStyle(fontSize: 30.0),
                ),
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
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Government Hospital'),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {},
                    child: Text('Private Hospital'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                height: 428, // Set a fixed height or use shrinkWrap
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1.2,
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
