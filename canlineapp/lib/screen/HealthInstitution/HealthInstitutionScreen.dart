import '../../widgets/BarrelFileWidget..dart';
import 'package:flutter/material.dart';
import '../../Layouts/BarrelFileLayouts.dart';


class HealthInstitutionScreen extends StatelessWidget {
  const HealthInstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Title(
            color: Color(0xFF000000),
            child: Text(
              "Health\nInstitution",
              style: TextStyle(fontSize: 50.0),
            ),
          ),
          const SizedBox(height: 20),
          SearchBar(
            autoFocus: false,
            leading: Icon(Icons.search),
            hintText: "Search",
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 20.0)),
          ),
          const SizedBox(height: 20),
          Row(
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
          const SizedBox(height: 20),
          Expanded(
            child: GridLayout(
              childrenProps: const [
                Carddesign1(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
