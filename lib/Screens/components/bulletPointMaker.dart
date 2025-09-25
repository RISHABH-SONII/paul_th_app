// import 'package:flutter/material.dart';
//
// class BulletPointMaker extends StatelessWidget {
//   final String label;
//   final String content;
//   final bool isLabelBold;
//   final bool showDot;
//
//   const BulletPointMaker({
//     super.key,
//     required this.label,
//     required this.content,
//     this.isLabelBold = false,
//     this.showDot = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return _bulletPointMaker();
//   }
//
//   Widget _bullet({bool isDot = true}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0, right: 8.0),
//       child: Text(
//         isDot ? "•" : "",
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }
//
//   Widget _bulletPointMaker() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _bullet(isDot: showDot),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: label,
//                     style: TextStyle(
//                       fontWeight: isLabelBold ? FontWeight.bold : FontWeight.normal,
//                       color: Colors.black,
//                     ),
//                   ),
//                   TextSpan(
//                     text: content,
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const BulletPoint(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•",style: style),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}