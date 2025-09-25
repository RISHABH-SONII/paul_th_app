// ListView(
//                     shrinkWrap: true,
//                     children: List.generate(5, (i) {
//                       return const ListTile(
//                         title: FractionallySizedBox(
//                           widthFactor: .9,
//                           alignment: Alignment.centerLeft,
//                           child: Skeleton(),
//                         ),
//                         subtitle: Padding(
//                           padding: EdgeInsets.only(top: 4),
//                           child: FractionallySizedBox(
//                             widthFactor: .5,
//                             alignment: Alignment.centerLeft,
//                             child: Skeleton(),
//                           ),
//                         ),
//                         horizontalTitleGap: 0,
//                         contentPadding: EdgeInsets.zero,
//                         leading: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Icon(
//                             Icons.circle,
//                             color: Color(0xFFf1f0ed),
//                             size: 20,
//                           ),
//                         ),
//                       );
//                     }))