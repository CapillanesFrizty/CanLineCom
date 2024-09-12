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
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60.0),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hello, Hanna Forger',
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xFF5B50A0),
                fontSize: 40.0,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          const SearchBarInfoHub(),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
                onPressed: toggleLayout,
              ),
            ],
          ),
          Expanded(
            child: isGrid
                ? GridView.count(
                    crossAxisCount: isPortrait ? 2 : 4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      CardHospital(onTap: () => handleCardTap('Hospital', 1)),
                      CardFinancial(onTap: () => handleCardTap('Financial', 3)),
                      CardBlogs(onTap: () => handleCardTap('Blogs', 2)),
                      CardClinic(onTap: () => handleCardTap('Clinics', 0)),
                    ],
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      CardHospital(onTap: () => handleCardTap('Hospital', 1)),
                      CardFinancial(onTap: () => handleCardTap('Financial', 3)),
                      CardBlogs(onTap: () => handleCardTap('Blogs', 2)),
                      CardClinic(onTap: () => handleCardTap('Clinics', 0)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}