import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Supportgroupslistscreen extends StatefulWidget {
  const Supportgroupslistscreen({super.key});

  static final List<Map<String, String>> supportGroups = [
    {
      'name': 'Philippine Cancer Society',
      'description':
          'The Philippine Cancer Society provides support and resources for cancer patients, including educational materials, counseling, and financial assistance.',
      'members': '100 members',
      'url': 'https://www.philcancer.org.ph/'
    },
    {
      'name': 'Cancer Warriors Foundation',
      'description':
          'Cancer Warriors Foundation supports children with cancer and their families through medical assistance, emotional support, and advocacy programs.',
      'members': '50 members',
      'url': 'https://www.c-warriors.org/'
    },
    {
      'name': 'ICanServe Foundation',
      'description':
          'ICanServe Foundation focuses on breast cancer awareness and support, offering early detection programs, patient navigation, and community-based support groups.',
      'members': '75 members',
      'url': 'https://www.icanservefoundation.org/'
    },
    {
      'name': 'Carewell Community',
      'description':
          'Carewell Community provides comprehensive support and resources for cancer patients and their families, including counseling, support groups, and wellness programs.',
      'members': '60 members',
      'url': 'https://www.carewellcommunity.org/'
    },
    {
      'name': 'Project: Brave Kids',
      'description':
          'Project: Brave Kids supports children with cancer and their families by providing medical assistance, emotional support, and educational resources.',
      'members': '40 members',
      'url': 'https://www.projectbravekids.org/'
    },
  ];

  @override
  State<Supportgroupslistscreen> createState() =>
      _SupportgroupslistscreenState();
}

class _SupportgroupslistscreenState extends State<Supportgroupslistscreen> {
  String searchQuery = '';

// View in Browser
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Supportgroupslistscreen.supportGroups.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(Icons.group),
              title:
                  Text(Supportgroupslistscreen.supportGroups[index]['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Supportgroupslistscreen.supportGroups[index]
                      ['description']!),
                  Text(
                      Supportgroupslistscreen.supportGroups[index]['members']!),
                ],
              ),
              onTap: () async {
                final url =
                    Supportgroupslistscreen.supportGroups[index]['url']!;
                if (!await launchUrl(Uri.parse(url))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class SupportGroupDetailScreen extends StatelessWidget {
  final Map<String, String> supportGroup;

  const SupportGroupDetailScreen({super.key, required this.supportGroup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supportGroup['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supportGroup['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              supportGroup['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Members: ${supportGroup['members']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportGroupSearch extends SearchDelegate {
  final List<Map<String, String>> supportGroups;

  SupportGroupSearch(this.supportGroups);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = supportGroups
        .where((group) =>
            group['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            leading: Icon(Icons.group),
            title: Text(results[index]['name']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(results[index]['description']!),
                Text(results[index]['members']!),
              ],
            ),
            onTap: () async {
              final url = results[index]['url']!;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $url')),
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = supportGroups
        .where((group) =>
            group['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['name']!),
          onTap: () {
            query = suggestions[index]['name']!;
            showResults(context);
          },
        );
      },
    );
  }
}
