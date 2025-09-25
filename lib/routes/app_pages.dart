import 'package:get/get.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormBinding.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormScreen.dart';

import 'package:tharkyApp/Screens/Splash.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/Screens/Welcome.dart';
import 'package:tharkyApp/Screens/auth/login.dart';
import 'package:tharkyApp/components/mapc/map_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      preventDuplicates: true,
      name: _Paths.paymentform,
      page: () => PaymentFormScreen(transaction: {}),
      title: null,
      binding: Paymentformbinding(),
    ),
    GetPage(
      preventDuplicates: true,
      name: _Paths.home,
      page: () => const MapViewHome({}),
      title: null,
    ),
    GetPage(
      preventDuplicates: true,
      name: _Paths.splash,
      page: () => Splash(),
      title: null,
    ),
    GetPage(
      preventDuplicates: true,
      name: _Paths.login,
      page: () => Login(),
      title: null,
    ),
    GetPage(
      preventDuplicates: true,
      name: _Paths.welcome,
      page: () => Welcome(),
      title: null,
    ),
    GetPage(
      preventDuplicates: true,
      name: _Paths.tabbar,
      page: () => Tabbar(null, null),
      title: null,
    ),
  ];
}
