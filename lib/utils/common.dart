import 'dart:convert';
import 'dart:io';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'constant.dart';

import 'dart:math';
import 'package:latlong2/latlong.dart';

bool get isUserTypeHandyman => appStore.userType == USER_TYPE_HANDYMAN;

bool get isUserTypeProvider => appStore.userType == USER_TYPE_PROVIDER;

bool get isUserTypeUser => appStore.userType == USER_TYPE_USER;

bool get isLoginTypeUser => appStore.loginType == LOGIN_TYPE_USER;

bool get isLoginTypeGoogle => appStore.loginType == LOGIN_TYPE_GOOGLE;

bool get isLoginTypeOTP => appStore.loginType == LOGIN_TYPE_OTP;

ThemeMode get appThemeMode =>
    appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light;

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!,
          launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!,
          launchMode: LaunchMode.externalApplication);
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + url!,
        launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void checkIfLink(BuildContext context, String value, {String? title}) {
  if (value.validate().isEmpty) return;

  String temp = parseHtmlString(value.validate());
  if (temp.startsWith("https") || temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    //HtmlWidget(postContent: value, title: title).launch(context);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<String> findLocalPath() async {
  final directory = Platform.isAndroid
      ? await (getExternalStorageDirectory())
      : await getApplicationDocumentsDirectory();
  return directory!.path;
}

void show_common_toast(String? text, BuildContext context) {
  showToast("$text",
      context: context,
      animation: StyledToastAnimation.slideFromLeft,
      reverseAnimation: StyledToastAnimation.slideToTop,
      fullWidth: true,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      textStyle: TextStyle(color: primaryColor),
      backgroundColor: whiteColor);
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    try {
      custom_tabs.launchUrl(
        Uri.parse(url!),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          shareState: custom_tabs.CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: custom_tabs.CustomTabsCloseButton(
            icon: custom_tabs.CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: true,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(
        id: 5,
        name: 'African',
        languageCode: 'af',
        fullLanguageCode: 'ar-AF',
        flag: 'assets/flag/ic_af.png'),
    LanguageDataModel(
        id: 6,
        name: 'Dutch',
        languageCode: 'nl',
        fullLanguageCode: 'nl-NL',
        flag: 'assets/flag/ic_nl.png'),
    LanguageDataModel(
        id: 7,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(
        id: 8,
        name: 'German',
        languageCode: 'de',
        fullLanguageCode: 'de-DE',
        flag: 'assets/flag/ic_de.png'),
    LanguageDataModel(
        id: 9,
        name: 'Indonesian',
        languageCode: 'id',
        fullLanguageCode: 'id-ID',
        flag: 'assets/flag/ic_id.png'),
    LanguageDataModel(
        id: 10,
        name: 'Spanish',
        languageCode: 'es',
        fullLanguageCode: 'es-ES',
        flag: 'assets/flag/ic_es.jpg'),
    LanguageDataModel(
        id: 11,
        name: 'Turkish',
        languageCode: 'tr',
        fullLanguageCode: 'tr-TR',
        flag: 'assets/flag/ic_tr.png'),
    LanguageDataModel(
        id: 12,
        name: 'Vietnam',
        languageCode: 'vi',
        fullLanguageCode: 'vi-VI',
        flag: 'assets/flag/ic_vi.png'),
    LanguageDataModel(
        id: 13,
        name: 'Albanian',
        languageCode: 'sq',
        fullLanguageCode: 'sq-SQ',
        flag: 'assets/flag/ic_arbanian.png'),
    LanguageDataModel(
        id: 14,
        name: 'Portugal',
        languageCode: 'pt',
        fullLanguageCode: 'pt-PT',
        flag: 'assets/flag/ic_pt.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon, String? labelText, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: context.cardColor,
  );
}

InputDecoration inputDecoration2(BuildContext context,
    {Widget? prefixIcon, String? labelText, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey, width: 2),
    ),
    filled: true,
    fillColor: Colors.black,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 16.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(width: 20),
    ),
  );
}

// String parseHtmlString(String? htmlString) {
//   return parse(parse(htmlString).body!.text).documentElement!.text;
// }

String formatDate(String? dateTime,
    {String format = DATE_FORMAT_1,
    bool isFromMicrosecondsSinceEpoch = false}) {
  if (isFromMicrosecondsSinceEpoch) {
    return DateFormat(format, "fr_FR").format(
        DateTime.fromMicrosecondsSinceEpoch(
            dateTime.validate().toInt() * 1000));
  } else {
    return DateFormat(format).format(DateTime.parse(dateTime.validate()));
  }
}

List getPaginatedList(List fullList, int pageNumber, int pageSize) {
  int startIndex = (pageNumber - 1) * pageSize;
  int endIndex = startIndex + pageSize;
  if (startIndex >= fullList.length) {
    return [];
  }
  if (endIndex > fullList.length) {
    endIndex = fullList.length;
  }
  return fullList.sublist(startIndex, endIndex);
}

// Logic For Calculate Time
String calculateTimer(int secTime) {
  int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft =
      hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2
      ? "0" + minute.toString()
      : minute.toString();

  String minutes = minuteLeft == '00' ? '01' : minuteLeft;

  String result = "$hourLeft:$minutes";

  log(seconds);

  return result;
}

String newCalculateTimer(int secTime) {
  int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft =
      hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2
      ? "0" + minute.toString()
      : minute.toString();

  String secondsLeft = seconds.toString().length < 2
      ? "0" + seconds.toString()
      : seconds.toString();

  String result = "$hourLeft:$minuteLeft:$secondsLeft";

  return result;
}

Brightness getStatusBrightness({required bool val}) {
  return val ? Brightness.light : Brightness.dark;
}

String getPaymentStatusText(String? status, String? method) {
  if (status!.isEmpty) {
    return 'Pending';
  } else if (status == SERVICE_PAYMENT_STATUS_PAID) {
    return 'Paid';
  } else if (status == SERVICE_PAYMENT_STATUS_PENDING &&
      method == PAYMENT_METHOD_COD) {
    return 'Pending Approval';
  }
  if (status == SERVICE_PAYMENT_STATUS_PENDING) {
    return 'Pending';
  } else {
    return "";
  }
}

String buildPaymentStatusWithMethod(String status, String method) {
  return '${getPaymentStatusText(status, method)}${status == SERVICE_PAYMENT_STATUS_PAID ? ' by ${method.capitalizeFirstLetter()}' : ''}';
}

Color getRatingBarColor(int rating) {
  if (rating == 1 || rating == 2) {
    return Color(0xFFE80000);
  } else if (rating == 3) {
    return Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return Color(0xFF73CB92);
  } else {
    return Color(0xFFE80000);
  }
}

int getAge(DateTime selecteddate) {
  return ((DateTime.now().difference(selecteddate).inDays) / 365.2425)
      .truncate();
}

bool get isCurrencyPositionLeft =>
    getStringAsync(CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) ==
    CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight =>
    getStringAsync(CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) ==
    CURRENCY_POSITION_RIGHT;

bool isTodayAfterDate(DateTime val) => val.isAfter(todayDate);

Widget mobileNumberInfoWidget() {
  return RichTextWidget(
    list: [
      TextSpan(
          text: 'Add your country code', style: secondaryTextStyle(size: 12)),
      TextSpan(text: ' "+33", "+44" ', style: boldTextStyle(size: 12)),
      TextSpan(
        text: ' (Help)',
        style: boldTextStyle(size: 12, color: primaryColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlCustomTab("https://countrycode.org/");
          },
      ),
    ],
  );
}

String getEllipsisText(String text, {int maxLength = 15}) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + '...';
  } else {
    return text;
  }
}

final _random = Random();

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String formatTimedecount(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

/// Generates a positive random integer uniformly distributed on the range
/// from [min], inclusive, to [max], exclusive.
int my_Random(int min, int max) => min + _random.nextInt(max - min);

double my_DoubleRandom(int min, int max) => min + _random.nextDouble() * max;

//bb is the bounding box, (ix,iy) are its top-left coordinates,
//and (ax,ay) its bottom-right coordinates. p is the point and (x,y)
//its coordinates.
//bbox = min Longitude , min Latitude , max Longitude , max Latitude
//[1.86735, -1.93359, 3.43099, 9.257474]

double generateBorderRadius() => Random().nextDouble() * 64;
double generateMargin() => Random().nextDouble() * 64;
Color generateColor() => Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));

bool pointIsInBoundedBox(List<double> bb, LatLng p) {
  bool isIn = false;

  // my_print("(((((((((((((");
  // my_print("$p");
  // my_print("${bb[0] <= p.longitude}");
  // my_print("${bb[1] <= p.latitude}");
  // my_print("${bb[2] >= p.longitude}");
  // my_print("${bb[3] >= p.latitude}");
  // my_print("(((((((((((((");

  if (bb[0] <= p.longitude &&
      bb[1] <= p.latitude &&
      bb[2] >= p.longitude &&
      bb[3] >= p.latitude) {
    isIn = true;
  }
  return isIn;
}

// Function to check if it's an image
bool isImage(String extension) {
  // You can expand this list as needed
  return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
}

// Function to check if it's a video
bool isVideo(String extension) {
  // You can expand this list as needed
  return ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.webm'].contains(extension);
}

void simulateScreenTap() {
  GestureBinding.instance.handlePointerEvent(PointerDownEvent(
    position: Offset(0, 0),
  ));
  GestureBinding.instance.handlePointerEvent(PointerUpEvent(
    position: Offset(0, 0),
  ));
}

void simulateCenterTap(BuildContext context) {
  // Get the screen size
  Size screenSize = MediaQuery.of(context).size;

  // Calculate the center position
  Offset center = Offset(screenSize.width / 2, screenSize.height / 2);

  // Simulate the PointerDown event at the center
  GestureBinding.instance.handlePointerEvent(PointerDownEvent(
    position: center,
  ));

  // Simulate the PointerUp event at the center
  GestureBinding.instance.handlePointerEvent(PointerUpEvent(
    position: center,
  ));
}

String getmesssageDate(String? date) {
  if (date == null || date.isEmpty) return "";

  DateTime messageDate = DateTime.parse(date);
  DateTime today = DateTime.now();

  if (messageDate.year == today.year &&
      messageDate.month == today.month &&
      messageDate.day == today.day) {
    // Retourner uniquement l'heure si c'est aujourd'hui
    return DateFormat.jm('en_US').format(messageDate);
  } else {
    // Retourner la date complète sinon
    return DateFormat.yMMMd('en_US').add_jm().format(messageDate);
  }
}

K? getRelativeKey<K, V>(Map<K, V> map, K key, int offset) {
  List<K> keys = map.keys.toList();
  int index = keys.indexOf(key);

  int targetIndex = index + offset;
  if (targetIndex >= 0 && targetIndex < keys.length) {
    return keys[targetIndex];
  }
  return null; // Return null if no valid key at the relative position
}

T? getNextElement<T>(List<T> list, int index) {
  return (index >= 0 && index < list.length - 1) ? list[index + 1] : null;
}

T? getPrevElement<T>(List<T> list, int index) {
  if ((index - 1) < 0) {
    return list[0];
  }
  return (index >= 0) ? list[index - 1] : null;
}
