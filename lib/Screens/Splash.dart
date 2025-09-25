import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/Screens/Welcome.dart';
import 'package:tharkyApp/Screens/auth/login.dart';
import 'package:tharkyApp/app_controller.dart';

class Splash extends StatelessWidget {
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (appController.isLoading.value) {
        print("under first condition ::::::");
        return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                  height: 120,
                  width: 200,
                  child: Image.asset(
                    "asset/applogo.jpg",
                    fit: BoxFit.contain,
                  )),
            ));
      } else if (!appController.isRegistered.value) {
        return Login();
      } else if (!appController.isAuth.value) {
        return Welcome();
      } else {
        return Tabbar(null, null);
      }
    });
  }
}
