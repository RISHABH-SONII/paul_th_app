import 'package:flutter/material.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/images.dart';

extension strEtx on String {
  Widget iconImage2({
    double? size,
    Color? color,
    BoxFit? fit,
  }) {
    return Container(
      height: size ?? 24,
      width: size ?? 24,
      child: Image.asset(
        this,
        fit: fit ?? BoxFit.cover,
        color: color ?? (appStore.isDarkMode ? Colors.white : secondryColor),
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            ic_no_photo,
            fit: fit ?? BoxFit.cover,
            color:
                color ?? (appStore.isDarkMode ? Colors.white : secondryColor),
          );
        },
      ),
    );
  }

  Widget iconImage({
    double? padding,
    Color? color,
    BoxFit? fit,
  }) {
    return Container(
      height: padding ?? 24,
      width: padding ?? 24,
      padding: EdgeInsets.all(padding != null ? padding : 0),
      child: Image.asset(
        this,
        fit: fit ?? BoxFit.cover,
        color: color ?? (appStore.isDarkMode ? Colors.white : secondryColor),
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            ic_no_photo,
            fit: fit ?? BoxFit.cover,
            color:
                color ?? (appStore.isDarkMode ? Colors.white : secondryColor),
          );
        },
      ),
    );
  }

  Color get fromHex {
    final buffer = StringBuffer();
    if (this.length == 6 || this.length == 7) buffer.write('ff');
    buffer.write(this.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
