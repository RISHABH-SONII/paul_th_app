import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:tharkyApp/Screens/Splash.dart';

import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/Screens/Welcome.dart';
import 'package:tharkyApp/Screens/auth/login.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/store/app_store.dart';

import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:intl/intl_standalone.dart';

AppStore appStore = AppStore();

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

  await initialize();
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

    // Set max distance
    await appStore.setMaxDistance(getIntAsync(MAX_DISTANCE).validate());

    // Set about info
    await appStore.setAbout(getStringAsync(ABOUT).validate());

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;
  List<String> testID = ['2DAA04BF7929E5D7DE7EE279D00172FA'];

  @override
  void initState() {
    super.initState();
    _checkAuth();
    // MobileAds.instance.initialize();
    // RequestConfiguration configuration =
    //     RequestConfiguration(testDeviceIds: testID);
    // MobileAds.instance.updateRequestConfiguration(configuration);
  }

  Future _checkAuth() async {
    int? userId = getIntAsync(USER_ID, defaultValue: 0);
    String? fullName = getStringAsync(USERNAME, defaultValue: "");
    if (userId != 0) {
      appStore.setLoading(true);
      await getUser(userId: '$userId').then((res) async {
        if (res.firstName != null) {
          await saveUserData(res);
          print("loggedin ${res.id}");
        }
      });
      isRegistered = true;

      appStore.setLoading(false);
    }

    setState(() {
      isLoading = false;
      if (fullName != " ") {
        isAuth = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: isLoading
          ? Splash()
          : !isRegistered
              ? Login()
              : !isAuth
                  ? Welcome()
                  : Tabbar(null, null),
    );
  }
}
