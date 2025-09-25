import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/common.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {Key? key,
      required this.title1,
      required this.title2,
      required this.onPositiveTap,
      required this.aspectRatio,
      this.positiveText})
      : super(key: key);

  final String title1;
  final String title2;
  final VoidCallback onPositiveTap;
  final double aspectRatio;
  final String? positiveText;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 8),
                      child: Text(
                        title1,
                        style: TextStyle(color: blackColor, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        title2,
                        style: TextStyle(
                          color: blackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: whiteColor.withOpacity(0.8), width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(Duration(seconds: 1), () {
                              simulateScreenTap();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? Colors.transparent
                                      : whiteColor.withOpacity(0.8),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: 17, color: blackColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: onPositiveTap,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Directionality.of(context) !=
                                          TextDirection.rtl
                                      ? Colors.transparent
                                      : whiteColor.withOpacity(0.8),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Text(
                              positiveText ?? "yes",
                              style: boldTextStyle(color: hotPink),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
