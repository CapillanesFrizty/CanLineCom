import 'package:flutter/material.dart';

class MoreinfoBlogsscreen extends StatelessWidget {
  const MoreinfoBlogsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// import 'package:flutter/material.dart';

// class MoreinfoBlogsscreen extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String author;
//   final String date;
//   final String content;

//   MoreinfoBlogsscreen({
//     required this.imageUrl,
//     required this.title,
//     required this.author,
//     required this.date,
//     required this.content,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blog'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Blog image
//               Image.network(imageUrl),
//               const SizedBox(height: 16),
              
//               // Blog title
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               const SizedBox(height: 8),
              
//               // Author and Date
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'By $author',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                   ),
//                   Text(
//                     date,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
              
//               // Blog content
//               Text(
//                 content,
//                 style: Theme.of(context).textTheme.bodyLarge,
//                 textAlign: TextAlign.justify,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MoreinfoBlogsscreen(
//       imageUrl: 'https://via.placeholder.com/400',
//       title: 'Understanding Flutter Widgets',
//       author: 'John Doe',
//       date: 'September 23, 2024',
//       content:
//           'Flutter is a powerful UI toolkit that allows you to build natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase. Its widget-based architecture enables developers to create highly customizable, responsive, and performant applications. With an extensive library of pre-designed widgets, Flutter makes it easy to build user interfaces, but also provides the flexibility to design custom widgets as needed.',
//     ),
//   ));
// }
