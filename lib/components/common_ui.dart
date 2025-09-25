import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/colors.dart';

class CommonUI {
  static void showToast(
      {required String msg,
      ToastGravity? toastGravity,
      int duration = 1,
      Color? backGroundColor}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: backGroundColor ?? deepPink,
      textColor: whiteColor,
      fontSize: 15.0,
    );
  }

  static void showLoader(BuildContext? context) {
    Get.dialog(LoaderDialog());
  }

  static void getLoader() {
    Get.dialog(LoaderDialog());
  }

  static Widget getWidgetLoader() {
    return Center(child: LoaderDialog());
  }
}

class LoaderDialog extends StatelessWidget {
  final double strokeWidth;

  LoaderDialog({this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
