import 'package:flutter/material.dart';
import 'package:tharkyApp/components/mapc/skeleton.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/images.dart'; // Assuming the `ic_arrow_left` is being used from here
import 'package:nb_utils/nb_utils.dart'; // You can remove this if it's not used in the updated widget
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class BackWidget extends StatelessWidget {
  final Function()? onPressed;
  final Color? iconColor;
  final double? size;
  final String? text;

  BackWidget({
    this.onPressed,
    this.iconColor,
    this.size,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            finish(context);
          },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ic_arrow_left.iconImage2(color: iconColor ?? Colors.white, size: 15),
          if (text != null && text!.isNotEmpty) SizedBox(width: 8),
          Text(
            "${text ?? "back"}".tr().toString(),
            style: primaryTextStyle(size: 10, color: white),
          ),
        ],
      ),
    );
  }
}

class BackWidgetuser extends StatelessWidget {
  final Function()? onPressed;
  final Color? iconColor;
  final double? size;
  final String? text;

  BackWidgetuser({
    this.onPressed,
    this.iconColor,
    this.size,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 50),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          elevation: 5,
          child: Row(
            children: [
              8.width,
              IconButton(
                padding: EdgeInsets.all(0),
                color: secondryColor,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          backgroundColor: white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

Widget errorImage() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.image_not_supported_rounded,
        color: Colors.black,
        size: 30,
      )
    ],
  ).withWidth(double.infinity);
}

Widget loadingImage() {
  return Center(
    child: FractionallySizedBox(
      widthFactor: .9,
      alignment: Alignment.centerLeft,
      child: Skeleton(
        height: 50,
        width: 50,
      ),
    ).paddingSymmetric(horizontal: 20),
  );
}
