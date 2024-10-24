import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/BarrelFileWidget..dart';
import 'package:flutter/material.dart';

class HealthInstitutionScreen extends StatelessWidget {
  HealthInstitutionScreen({super.key});

  final _future = Supabase.instance.client.from('health_institutions').select();

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
            // FutureBuilder to handle fetching data and rendering the cards
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Cast snapshot.data to List<Map<String, dynamic>>
                final List<Map<String, dynamic>> healthinst =
                    snapshot.data as List<Map<String, dynamic>>;

                if (healthinst.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: SizedBox(
                    height: 500, // Set a fixed height or use shrinkWrap
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1 / 1.2,
                      ),
                      itemCount: healthinst.length,
                      itemBuilder: (context, index) {
                        final healthinstdata = healthinst[index];
                        return CardDesign1(
                          goto: () {
                            debugPrint('ID:${healthinstdata['id']}');
                            context.go(
                                '/Health-Insititution/${healthinstdata['id']}');
                          },
                          title: healthinstdata['name_of_health_institution'] ??
                              'Unknown Name',
                          subtitle: healthinstdata['type_of_hospital'] ??
                              'Unknown Type',
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
