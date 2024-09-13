import 'package:flutter/material.dart';
import 'package:canerline_app/widgets/hospital/Cards/CardHospital.dart';
import 'package:canerline_app/widgets/financial assistance/cards/CardFinancial.dart';
import 'package:canerline_app/widgets/clinics/cards/CardClinics.dart';
import 'package:canerline_app/widgets/blogs/cards/CardBlogs.dart';
import 'package:canerline_app/widgets/homescreen/searchbar/SearchBar.dart';

class Infohub extends StatefulWidget {
  const Infohub({super.key});

  @override
  State<Infohub> createState() => _InfohubState();
}

class _InfohubState extends State<Infohub> {
  bool isGrid = true;

  void toggleLayout() => setState(() => isGrid = !isGrid);

  void handleCardTap(String cardType, int index) {
    print('$cardType Card $index tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfohubBody(
        isGrid: isGrid,
        toggleLayout: toggleLayout,
        handleCardTap: handleCardTap,
      ),
    );
  }
}

class InfohubBody extends StatelessWidget {
  final bool isGrid;
  final VoidCallback toggleLayout;
  final void Function(String cardType, int index) handleCardTap;

  const InfohubBody({
    super.key,
    required this.isGrid,
    required this.toggleLayout,
    required this.handleCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontFamily: 'GilroyLight',
                    color: Color(0xFF5B50A0),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Hanna Forger!',
                  style: TextStyle(
                    fontFamily: 'GilroyLight',
                    color: Color(0xFF5B50A0),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          const SearchBarInfoHub(),
          const SizedBox(height: 30.0),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 10.0), // Add margin here
                      child: IconButton(
                        icon: Icon(
                          isGrid ? Icons.view_list : Icons.grid_view,
                          color: const Color(0xFF5B50A0),
                          size: 30.0,
                        ),
                        onPressed: toggleLayout,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: isGrid
                      ? GridView.count(
                          crossAxisCount: isPortrait ? 2 : 4,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                          childAspectRatio: 160.0 / 185.0,
                          children: [
                            CardHospital(
                                onTap: () => handleCardTap('Hospital', 1)),
                            CardFinancial(
                                onTap: () => handleCardTap('Financial', 3)),
                            CardBlogs(onTap: () => handleCardTap('Blogs', 2)),
                            CardClinic(
                                onTap: () => handleCardTap('Clinics', 0)),
                          ],
                        )
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            CardHospital(
                                onTap: () => handleCardTap('Hospital', 1)),
                            CardFinancial(
                                onTap: () => handleCardTap('Financial', 3)),
                            CardBlogs(onTap: () => handleCardTap('Blogs', 2)),
                            CardClinic(
                                onTap: () => handleCardTap('Clinics', 0)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
