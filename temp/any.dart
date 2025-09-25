// // ignore_for_file: avoid_dynamic_calls
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tharkyApp/components/mapc/home_controller.dart';
// import 'package:tharkyApp/models/proposed_place.dart';
// import 'package:tharkyApp/res/global_worker.dart';
//
// class ProposedLieu extends StatelessWidget {
//   final HomeController homeController;
//   const ProposedLieu({Key? key, required this.homeController})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final widgets = List.generate(
//         homeController.proposedPlaces.value.length,
//         (i) => ProposedPlaceCard(
//             proposedPlace: homeController.proposedPlaces.value[i]));
//
//     void _onGoClick() {
//       homeController.settingTripPoint = "origin";
//     }
//
//     return Wrap(
//       children: [
//         WhereWeGoInput(onGoClick: _onGoClick, homeController: homeController),
//         ...widgets,
//       ],
//     );
//   }
// }
//
// class WhereWeGoInput extends StatelessWidget {
//   final void Function()? onGoClick;
//   final HomeController homeController;
//   const WhereWeGoInput({Key? key, this.onGoClick, required this.homeController})
//       : super(key: key);
//
//   void showshow(BuildContext context) {
//     homeController.togglePlacePicker();
//     YGWorker.onWillPop = () async {
//       homeController.toggleNearestSheet();
//       YGWorker.onWillPop = () async {
//         return Future<bool>.value(true);
//       };
//       return Future<bool>.value(false);
//     };
//
//     // showMaterialModalBottomSheet<dynamic>(
//     //     context: context,
//     //     backgroundColor: Colors.white,
//     //     barrierColor: Colors.black45,
//     //     clipBehavior: Clip.none,
//     //     enableDrag: true,
//     //     useRootNavigator: true,
//     //     elevation: 10,
//     //     shape: const RoundedRectangleBorder(
//     //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//     //     ),
//     //     builder: (context) {
//     //       return SingleChildScrollView(
//     //         controller: ModalScrollController.of(context),
//     //         child: const WherWeGoSheet(),
//     //       );
//     //     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFf1f0ed),
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//         ),
//         margin: const EdgeInsets.all(5),
//         width: double.infinity,
//         height: 50,
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/static/ic_tariff_cargo_loaders_2.png',
//                 ),
//                 Text(
//                   "where_we_go".tr,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 )
//               ],
//             ),
//             const Padding(
//               padding: EdgeInsets.only(bottom: 2),
//               child: Icon(
//                 Icons.arrow_forward,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//       onTap: () {
//         onGoClick!();
//         showshow(context);
//       },
//     );
//   }
// }
//
// class ProposedPlaceCard extends StatelessWidget {
//   final ProposedPlace proposedPlace;
//   const ProposedPlaceCard({Key? key, required this.proposedPlace})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//       widthFactor: proposedPlace.persistance,
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFf1f0ed),
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//         ),
//         margin: const EdgeInsets.all(5),
//         padding: const EdgeInsets.all(10),
//         height: 100,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               proposedPlace.localname,
//               overflow: proposedPlace.persistance <= .33
//                   ? TextOverflow.ellipsis
//                   : null,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Image.asset(
//                   'assets/static/ic_logistics_task_car.png',
//                   width: 50,
//                 ),
//                 Image.asset(
//                   'assets/static/prop_located.png',
//                   width: 28.9,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

///Commented by Shubham
