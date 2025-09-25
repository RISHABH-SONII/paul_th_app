import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/routes/app_pages.dart';
import 'package:tharkyApp/store/app_store.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AppStore appStore = AppStore();
AppController appController = Get.find<AppController>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  EasyLocalization.logger.enableBuildModes = [];

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.systemLocale = await findSystemLocale();
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await initialize();
  await initializeDateFormatting();
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  await EasyLocalization.ensureInitialized();
  if (appStore.isLoggedIn) {
    // Set token if available
    String token = getStringAsync(TOKEN);
    if (token.validate().isNotEmpty) await appStore.setToken(token);

    // Set basic user info
    await appStore.setUserId(getIntAsync(USER_ID).validate());
    await appStore.setFirstName(getStringAsync(FIRST_NAME).validate());
    await appStore.setLastName(getStringAsync(LAST_NAME).validate());
    await appStore.setUserEmail(getStringAsync(USER_EMAIL).validate());
    await appStore.setUserName(getStringAsync(USERNAME).validate());
    await appStore.setAddress(getStringAsync(ADDRESS).validate());

    // Set coordinates (if available)
    String coordinates = getStringAsync(COORDINATE);
    if (coordinates.validate().isNotEmpty) {
      final rawCoordinates = jsonDecode(coordinates) as Map<dynamic, dynamic>;
      final formattedCoordinates = ObservableMap<String, String>.of(
        rawCoordinates.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ),
      );
      await appStore.setCoordinates(formattedCoordinates);
    }

    // Set user profile image URL if available
    String profileImage = getStringAsync(PROFILE_IMAGE);
    if (profileImage.validate().isNotEmpty) {
      await appStore.setImageUrl([profileImage]);
    }

    // Set additional user info
    await appStore.setPhoneNumber(getStringAsync(PHONE_NUMBER).validate());
    await appStore.setGender(getStringAsync(GENDER).validate());
    await appStore.setShowGender(getStringAsync(SHOW_GENDER).validate());

    // Age range (if available)
    String ageRange = getStringAsync(AGE_RANGE);
    if (ageRange.validate().isNotEmpty) {
      final rawAgeRange = jsonDecode(ageRange) as Map<dynamic, dynamic>;
      final formattedAgeRange = rawAgeRange.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await appStore.setAgeRange(formattedAgeRange);
    }
    String meta = getStringAsync(META);
    if (meta.validate().isNotEmpty) {
      final rawAgeRange = jsonDecode(meta) as Map<dynamic, dynamic>;
      final formattedmeta = rawAgeRange.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await appStore.setMeta(formattedmeta);
    }

    // Set max distance
    await appStore.setMaxDistance(getIntAsync(MAX_DISTANCE).validate());

    // Set about info
    await appStore.setAbout(getStringAsync(ABOUT).validate());
    await appStore.set_id(getStringAsync("IID").validate());

    // Set last online (if available)
    int? lastOnline = getIntAsync(LAST_ONLINE);

    await appStore.setLastOnline(lastOnline);

    // Set lists (favorites, images, interests)
    await appStore.setFavorites(
      (getStringListAsync(FAVORITES) ?? []).map((e) => e.toString()).toList(),
    );
    await appStore.setImages(
      (getStringListAsync(IMAGES) ?? []).map((e) => e.toString()).toList(),
    );
    await appStore.setPrivates(
      (getStringListAsync(PRIVATES) ?? []).map((e) => e.toString()).toList(),
    );
    await appStore.setInterests(
      (getStringListAsync(INTERESTS) ?? []).map((e) => e.toString()).toList(),
    );

    // Set level info
    await appStore.setLevel(getStringAsync(LEVEL).validate());

    // Mark user as logged in
    appStore.setLoggedIn(true);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('es', 'ES')],
      path: 'asset/translation',
      saveLocale: true,
      fallbackLocale: Locale('en', 'US'),
      child: new MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  final AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    Rks.context = context;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      title: 'Tharky',
      getPages: AppPages.routes,
      initialRoute: '/splash',
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
    );
  }
}
