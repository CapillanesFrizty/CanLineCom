import 'package:flutter/material.dart';
import '../../Layouts/GridViewLayout/GridViewLayout.dart';
import '../../Layouts/Scaffold/ScaffoldLayout.dart';
import '../../widgets/Card/InkwellcardwidgetWidget.dart';
import '../../widgets/Scaffold/Actionsbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayoutWidget(
      bodyWidget: Padding(
        padding: const EdgeInsets.all(30.0),
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
              children: const [
                ActionsButtons(
                  icon: Icon(Icons.grid_3x3_outlined),
                ),
                SizedBox(width: 10),
                ActionsButtons(
                  icon: Icon(Icons.view_column_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridViewLayout(
                childrenPorps: const [
                  Inkwellcardwidget(
                      label: "Health\nInstitution",
                      iconAsset: 'lib/assets/icons/Hospital.svg',
                      textColor: 0xffff5267,
                      bgColor: 0xffffd7db,
                      iconColor: 0xffff5267),
                  Inkwellcardwidget(
                      label: "Financial\nSupport",
                      iconAsset: 'lib/assets/icons/Financial.svg',
                      textColor: 0xff3cc34f,
                      bgColor: 0xffcbffd2,
                      iconColor: 0xff3cc34f),
                  Inkwellcardwidget(
                      label: "Blogs/News",
                      iconAsset: 'lib/assets/icons/Blogs.svg',
                      textColor: 0xffffa133,
                      bgColor: 0xffffead1,
                      iconColor: 0xffffa133),
                  Inkwellcardwidget(
                      label: "Clinics\n(External)",
                      iconAsset: 'lib/assets/icons/Clinics.svg',
                      textColor: 0xff3f52ff,
                      bgColor: 0xffd9ddff,
                      iconColor: 0xffff5267),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsWidget: const [
        ActionsButtons(
          icon: Icon(Icons.notifications_outlined),
        ),
        SizedBox(width: 8),
        ActionsButtons(
          icon: Icon(Icons.verified_user_outlined),
        ),
      ],
    );
  }
}
