import 'package:flutter/material.dart';
import '../../Layouts/ListViewLayout/ListViewLayout.dart';
import '../../widgets/BarrelFileWidget..dart';
import 'package:go_router/go_router.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchField(),
            _buildSectionTitle("Popular Blogs"),
            _buildPopularBlogsList(context),
            _buildSectionTitle("Recent Blogs"),
            _buildRecentBlogs(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        "Blogs",
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPopularBlogsList(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.go('/Blog/More-Info-Blogs'),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Popular Blog ${index + 1}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBlogs(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.go('/Blog/More-Info-Blogs'),
          child: CardDesign3List(),
        ),
      ],
    );
  }
}
