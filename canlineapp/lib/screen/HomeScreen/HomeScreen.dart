import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Layouts/BarrelFileLayouts.dart';
import '../../widgets/BarrelFileWidget..dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Title(
            color: Colors.black,
            child: Text(
              "Hello\nHanna Forge",
              style: TextStyle(fontSize: 50.0),
            ),
          ),
          const SizedBox(height: 20),
          SearchBar(
            autoFocus: false,
            leading: Icon(Icons.search),
            hintText: "Search",
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Icon(Icons.grid_3x3_outlined),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () {},
                child: Icon(Icons.view_column_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridLayout(
              childrenProps: [
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
                  iconColor: 0xffff5267,
                  goto: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
