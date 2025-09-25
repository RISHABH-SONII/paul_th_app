import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/components/mapc/map_view.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:get/get.dart';

import 'UpdateLocation.dart';
//import 'package:geolocator/geolocator.dart';

class AllowLocation extends StatelessWidget {
  final Map<String, dynamic> userData;

  AllowLocation(this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10), child: BackWidgetuser()),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                20.height,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/enable_location.png",
                        fit: BoxFit.contain,
                        height: 350,
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: easy.tr("Enable location"),
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: easy
                              .tr(
                                  "\nYou'll need to provide a \nlocation\nin order to search users around you.")
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: secondryColor,
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 14)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                20.height,
                Text(
                  easy.tr("Or").toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: blackColor),
                ).paddingSymmetric(vertical: 15),
                10.height,
                AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 5000),
                    child: Container(
                      height: 42,
                      child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        heroTag: UniqueKey(),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          // Register your HomeController before running the app
                          Get.put(
                              HomeController()); // You can use Get.lazyPut if you want it to be created lazily
                          Get.to(() => MapViewHome(userData));
                        },
                        label: "asset/icons/choose_location.png"
                            .iconImage2(size: 30, color: black),
                        icon: Text("Pick"),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                primaryColor.withOpacity(.5),
                                primaryColor.withOpacity(.8),
                                primaryColor,
                                primaryColor
                              ])),
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .75,
                      child: Center(
                          child: Text(
                        "ALLOW LOCATION".toString(),
                        style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ))),
                  onTap: () async {
                    var currentLocation = await getLocationCoordinates();

                    if (currentLocation != null) {
                      userData.addAll(
                        {
                          'coordinates': {
                            'latitude': currentLocation['latitude'],
                            'longitude': currentLocation['longitude'],
                            'address': currentLocation['PlaceName'],
                          },
                          'maxDistance': 20,
                          'ageRange': {
                            'min': "20",
                            'max': "50",
                          },
                        },
                      );

                      await setUserData(userData);

                      showWelcomDialog(context);
                    }
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Future setUserData(Map<String, dynamic> userData) async {
  final user = User(
    name: userData[UserKeys.userName],
    dob: userData[UserKeys.dob] != null
        ? DateTime.parse(userData[UserKeys.dob])
        : null,
    gender: userData[UserKeys.gender],
    showGender: userData["showGender"],
    maxDistance: userData["maxDistance"],
    ageRange: userData["ageRange"],
    about: userData[UserKeys.about],
    coordinates: userData["coordinates"],
    interests: userData[UserKeys.interests] != null
        ? List<String>.from(userData[UserKeys.interests]['tags'])
        : null,
    showInterests: userData[UserKeys.interests]['showOnProfile'],
  );

  await edituser(user.toJson()).then((value) async {
    saveUserData(value.data!);
  }).catchError((e) {
    // toast(e.toString());
  });
}

Future showWelcomDialog(context) async {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        });
        return Center(
          child: Container(
              width: MediaQuery.of(context).size.width/2.5,
              height: MediaQuery.of(context).size.height/7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: <Widget>[
                  15.height,
                  Icon(
                    Icons.check_circle,
                    color: greenColor,
                    size: 50.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    "you are in".toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              )),
        );
      });
}
