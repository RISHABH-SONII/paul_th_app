import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/res/global_worker.dart';
import 'package:tharkyApp/routes/app_pages.dart';
import 'package:tharkyApp/utils/colors.dart'; // Ensure GetX is imported

void main() {
  // Register your HomeController before running the app
  Get.put(
      HomeController()); // You can use Get.lazyPut if you want it to be created lazily

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        home: WillPopScope(
            onWillPop: () {
              return YGWorker.onWillPop();
            },
            child: GetMaterialApp(
              title: 'yambro',
              getPages: AppPages.routes,
              initialRoute: AppPages.initial,
              locale: const Locale('fr', 'FR'),
              fallbackLocale: const Locale('fr', 'FR'),
            )));
  }
}
