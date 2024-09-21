import 'package:flutter/material.dart';
import '../../Layouts/ListViewLayout/ListViewLayout.dart';
import '../../widgets/BarrelFileWidget..dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Listviewlayout(
        childrenProps: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Blogs",
              style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
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
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Popular Blogs",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
          Carddesign2Carousellist(),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Recent Blogs",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
          CardDesign3List() // Your card carousel goes here
        ],
      ),
    );
  }
}

