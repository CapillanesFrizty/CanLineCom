import 'package:flutter/material.dart';

class ClinicScreen extends StatelessWidget {
  const ClinicScreen({super.key});

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
                  "Cinics",
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
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              child: SizedBox(
                height: 450, // Set a fixed height or use shrinkWrap
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1.2,
                  children: const [
                    // CardDesign1(
                    //   goto: () {
                    //     context.go('/Health-Insititution/More-Info');
                    //   },
                    //   image: ''const Icon(Icons.broken_image),
                    //   title: 'Clinic1',
                    //   subtitle: 'Government Clinic',
                    // )
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
