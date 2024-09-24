import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Layouts/BarrelFileLayouts.dart';
import '../../widgets/BarrelFileWidget..dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 25),
          child: Text(
            "Hello\nHanna Forge",
            style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.normal),
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
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Icon(Icons.grid_3x3_outlined),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {},
                child: const Icon(Icons.view_column_outlined),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: GridView.count(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1 / 1.2,
            shrinkWrap: true, // Shrinks the grid view height to its content
            physics:
                NeverScrollableScrollPhysics(), // Prevents scrolling inside GridView
            children: [
              Inkwellcardwidget(
                label: "Health\nInstitution",
                iconAsset: 'lib/assets/icons/Hospital.svg',
                textColor: 0xffff5267,
                bgColor: 0xffffd7db,
                iconColor: 0xffff5267,
                goto: () => context.go('/Health-Insititution'),
              ),
              Inkwellcardwidget(
                label: "Financial\nSupport",
                iconAsset: 'lib/assets/icons/Financial.svg',
                textColor: 0xff3cc34f,
                bgColor: 0xffcbffd2,
                iconColor: 0xff3cc34f,
                goto: () {
                  context.go('/Financial-Support');
                },
              ),
              Inkwellcardwidget(
                label: "Blogs/News",
                iconAsset: 'lib/assets/icons/Blogs.svg',
                textColor: 0xffffa133,
                bgColor: 0xffffead1,
                iconColor: 0xffffa133,
                goto: () => context.go('/Blog'),
              ),
              Inkwellcardwidget(
                label: "Clinics\n(External)",
                iconAsset: 'lib/assets/icons/Clinics.svg',
                textColor: 0xff3f52ff,
                bgColor: 0xffd9ddff,
                iconColor: 0xff3f52ff,
                goto: () => context.go('/clinic'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
