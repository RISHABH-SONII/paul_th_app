import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tharkyApp/utils/common.dart';

class BlockUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondryColor.withOpacity(.5),
      body: AlertDialog(
        actionsPadding: EdgeInsets.all(10),
        backgroundColor: Colors.white,
        actions: [
          Center(
              child: RichTextWidget(
            list: [
              TextSpan(
                  text: "for more info visit:  ",
                  style: secondaryTextStyle(size: 15)),
              TextSpan(
                text: "Click here",
                style: secondaryTextStyle(color: primaryColor, size: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    commonLaunchUrl(
                        "https://thenastycollectorsnastycollection.com/next-gen-dates-app/");
                  },
              ),
            ],
          )).paddingBottom(40),
        ],
        title: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                      height: 50,
                      width: 100,
                      child: Image.asset(
                        "asset/hookup4u-Logo-BW.png",
                        fit: BoxFit.contain,
                      )),
                )),
            Text(
              "sorry, you can't access the application!".tr().toString(),
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        content: Text(
          "you're blocked by the admin and your profile will also not appear for other users."
              .tr()
              .toString(),
        ),
      ),
    );
  }
}
