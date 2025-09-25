// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page View',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const PageViewCustom(),
//     );
//   }
// }

// class PageViewCustom extends StatefulWidget {
//   const PageViewCustom({Key? key}) : super(key: key);

//   @override
//   State<PageViewCustom> createState() => _PageViewCustomState();
// }

// class _PageViewCustomState extends State<PageViewCustom> {
//   final _pageController = PageController(
//     initialPage: 1,
//     viewportFraction: 1,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         scrollDirection: Axis.horizontal, // or Axis.vertical
//         children: [
//           Container(
//             color: Colors.red,
//             child: const Center(
//               child: Text(
//                 'RED PAGE',
//                 style: TextStyle(
//                   fontSize: 45,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.blue,
//             child: const Center(
//               child: Text(
//                 'BLUE PAGE',
//                 style: TextStyle(
//                   fontSize: 45,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
