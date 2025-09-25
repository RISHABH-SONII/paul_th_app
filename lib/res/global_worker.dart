// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

Map<String, dynamic> YGlobalWorker = {
  "home": {
    "sheetPosToShowInputs": false,
    "tolerable_request_second": 1050,
    "deliveryOrigin": "",
    "deliveryDestination": "",
    "go_to_inputs": false
  },
  "base_url": "",
  "app_mail": "medisadido@gmail.com",
  "backButtonPress": {
    "context": null,
  },
  "tmp": "roro",
};

enum YEnumerate { NearestPlace, WhereWeGoSheet, BeforeCourseDetails }

class YGWorker {
  YGWorker();
  static String deliveryOrigin = "";
  static String deliveryDestination = "";
  static GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  static Future<bool> Function() onWillPop = () async {
    return Future<bool>.value(false);
  };

  static void setOnWillPop(Future<bool> Function() fn) async {
    onWillPop = fn;
  }
}
