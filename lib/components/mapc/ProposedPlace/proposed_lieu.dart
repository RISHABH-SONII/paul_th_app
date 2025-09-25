// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/AllowLocation.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/res/global_worker.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class ProposedLieu extends StatelessWidget {
  final HomeController homeController;
  final Map<String, dynamic> userData;
  const ProposedLieu(
      {Key? key, required this.homeController, required this.userData})
      : super(key: key);
  void showshow(BuildContext context) {
    YGWorker.onWillPop = () async {
      homeController.toggleNearestSheet();
      YGWorker.onWillPop = () async {
        return Future<bool>.value(true);
      };
      return Future<bool>.value(false);
    };
  }

  @override
  Widget build(BuildContext context) {
    void _onGoClick() {}

    return Wrap(
      children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFf1f0ed),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "asset/icons/choose_location.png"
                      .iconImage2(size: 30, color: blackColor),
                  8.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          easy.tr(
                              "${homeController.proposedPlaces.value["formatedAddress"]}"),
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          easy.tr(
                              "${homeController.proposedPlaces.value["address"]}"),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: secondryColor,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ).marginOnly(top: 20),
            ),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 5000),
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 2,
                heroTag: UniqueKey(),
                backgroundColor: Colors.white,
                onPressed: () async {
                  if (!homeController.loading.value) {
                    Map<String, dynamic> userDatae = Map.from(userData);

                    userDatae.addAll({
                      'coordinates': {
                        'latitude': homeController.proposedPlaces['lat'],
                        'longitude': homeController.proposedPlaces['lon'],
                        'address':
                            homeController.proposedPlaces['formatedAddress'],
                      },
                      'maxDistance': 20,
                      'ageRange': {
                        'min': "20",
                        'max': "50",
                      },
                    });
                    homeController.sheetIsDraggable.value = true;
                    if (userData["editing"] == 1) {
                      Get.back(
                        result: userDatae,
                      );
                    } else {
                      await setUserData(userDatae);
                      showWelcomDialog(context);
                    }
                  }
                },
                label: !homeController.loading.value
                    ? Text('Ok')
                    : const CircularProgressIndicator(
                        color: redColor,
                      ),
                icon:
                    "asset/icons/ic_ok.png".iconImage2(size: 30, color: black),
              ),
            ).marginOnly(bottom: 30),
          ],
        )
      ],
    );
  }
}
