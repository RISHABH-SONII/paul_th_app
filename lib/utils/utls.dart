// ignore_for_file: inference_failure_on_untyped_parameter, non_constant_identifier_names, avoid_print, type_annotate_public_apis

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tharkyApp/Screens/Tab.dart';

void my_print(var ______________________) {
  //print('\x1B[32m${StackTrace.current}\x1B[0m');
  print('\x1B[32m$______________________\x1B[0m');
}

void my_print_err(var text) {
  print('\x1B[33m$text\x1B[0m');
}

String? imageUrl(var text, {bool jaipaye = false}) {
  String profil_url =
      """${BASE_URL}images${jaipaye ? "/${generateRandomStrings(5)}" : ""}/${text}?&rloli=${appStore.token}""";

  return profil_url;
}

String? videoUrl(var text, {bool thumbnail = false, bool jaipaye = false}) {
  String profil_url =
      """${BASE_URL}videos${jaipaye ? "/${generateRandomStrings(5)}" : ""}/${text}?&rloli=${appStore.token}${thumbnail ? "&preview=thumbnail" : ""}""";

  return profil_url;
}

void my_inspect(var text) {
  // print('\x1B[32m${StackTrace.current}\x1B[0m');

  inspect(text);
}

final _random = Random();

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

String generateRandomStrings(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

int countVideos(List<String> privates) {
  return privates.where((item) => item.startsWith("fed")).length;
}

int countImages(List<String> privates) {
  return privates.where((item) => !item.startsWith("fed")).length;
}

Future<void> showNotification(Map payload, {type = "call", id = 55555}) async {
  switch (type) {
    case "call":
      final Int64List vibrationPattern = Int64List(16);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 50;
      vibrationPattern[2] = 50;
      vibrationPattern[3] = 50;
      vibrationPattern[4] = 50;
      vibrationPattern[5] = 50;
      vibrationPattern[6] = 50;
      vibrationPattern[7] = 50;
      vibrationPattern[8] = 50;
      vibrationPattern[9] = 50;
      vibrationPattern[10] = 50;
      vibrationPattern[11] = 50;
      vibrationPattern[12] = 50;
      vibrationPattern[13] = 50;
      vibrationPattern[14] = 4000;
      vibrationPattern[15] = 10;

      const int insistentFlag = 4;

      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              ONESIGNAL_CHANNEL_ID, ONESIGNAL_CHANNEL_NAME,
              channelDescription: ONESIGNAL_CHANNEL_DESCRIPTION,
              importance: Importance.max,
              priority: Priority.high,
              vibrationPattern: vibrationPattern,
              ledOnMs: 1000,
              ledOffMs: 500,
              enableLights: true,
              color: const Color.fromARGB(255, 255, 0, 0),
              ledColor: const Color.fromARGB(255, 255, 0, 0),
              additionalFlags: Int32List.fromList(<int>[insistentFlag]),
              tag: 'calltag');
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await flutterLocalNotificationsPlugin.show(
          id, payload["title"], payload["body"], notificationDetails);
      break;
    case "calli":
      final Int64List vibrationPattern = Int64List(4);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 1000;
      vibrationPattern[2] = 5000;
      vibrationPattern[3] = 2000;

      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              'other custom channel id', 'other custom channel name',
              channelDescription: 'other custom channel description',
              icon: 'hookup4ulogobp',
              largeIcon: const DrawableResourceAndroidBitmap('hookup4ulogobp'),
              vibrationPattern: vibrationPattern,
              enableLights: true,
              color: const Color.fromARGB(255, 255, 0, 0),
              ledColor: const Color.fromARGB(255, 255, 0, 0),
              ledOnMs: 1000,
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              additionalFlags: Int32List.fromList(<int>[4]),
              ledOffMs: 500);

      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          id++,
          'title of notification with custom vibration pattern, LED and icon',
          'body of notification with custom vibration pattern, LED and icon',
          notificationDetails);
      break;
    default:
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('roar-beauty', 'Roar Beauty',
              channelDescription: 'channel for roar',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(Rks.idnotifications++,
          payload["title"], payload["body"], notificationDetails,
          payload: 'item x');
  }
}

Future<void> cancelNotificationWithTag() async {
  await flutterLocalNotificationsPlugin.cancel(55555, tag: 'calltag');
}

void myprint(var text) {
  print('\x1B[33m---------------------------------------\x1B[0m');
  print('\x1B[33m$text\x1B[0m');
  print('\x1B[33m---------------------------------------\x1B[0m');
}

bool isVideofed(String text) {
  return "${text}".contains("fed");
}

void myprintnet(var text) {
  print('\x1B[35m$text\x1B[0m');
}

void myprint2(var text) {
  print('\x1B[37m$text\x1B[0m');
}

void initNotifications({setState, context}) async {
  int id = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  const String portName = 'notification_send_port';

  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  const String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  const String darwinNotificationCategoryPlain = 'plainCategory';

  bool _notificationsEnabled;

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('hookup4ulogobp');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  if (Platform.isAndroid) {
    final bool granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;

    setState(() {
      _notificationsEnabled = granted;
    });
  }

  // Future<void> _requestPermissions() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? grantedNotificationPermission =
        await androidImplementation?.requestNotificationsPermission();
    setState(() {
      _notificationsEnabled = grantedNotificationPermission ?? false;
    });
  }

  // void _configureSelectNotificationSubject() {
  selectNotificationStream.stream.listen((String? payload) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => Tabbar(null, false),
    ));
  });
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

String? getCurrentRouteName(BuildContext context) {
  // Récupère la route actuelle
  final route = ModalRoute.of(context);
  if (route != null) {
    // Retourne le nom de la route si elle est nommée
    return route.settings.name;
  }
  return null;
}
