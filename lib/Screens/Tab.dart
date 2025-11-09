import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Swipes.dart';
import 'package:tharkyApp/Screens/Profile/profile.dart';
import 'package:tharkyApp/Screens/blockUserByAdmin.dart';
import 'package:tharkyApp/Screens/components/privatepubliclytotal.dart';
import 'package:tharkyApp/Screens/notifications.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/components/loader_widget.dart';
import 'package:tharkyApp/main.dart';

import 'package:tharkyApp/models/searchuser_model.dart';
import 'package:tharkyApp/models/user_model.dart' as userD;
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/initio.dart';
import 'package:tharkyApp/utils/low_score_dialogue.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'Chat/home_screen.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart' as el;

import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

List likedByList = [];

class Tabbar extends StatefulWidget {
  final bool? isPaymentSuccess;
  final String? plan;

  Tabbar(this.plan, this.isPaymentSuccess);

  @override
  TabbarState createState() => TabbarState();
}

//_
class TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  userD.User? currentUser;
  List<SearchUser> users = [];
  Map likedMap = {};
  Map disLikedMap = {};
  late TabController _tabController;
  final AppController appController = Get.find<AppController>();

  List<PurchaseDetails> purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  InAppPurchase _iap = InAppPurchase.instance;
  bool isPuchased = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      // This forces a rebuild when the tab changes
      setState(() {});
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      setState(() {
        purchases.addAll(purchaseDetailsList);
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      _subscription!.cancel();
    });
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess!) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: el.tr("Confirmation"),
          desc: el.tr("You have successfully subscribed to our ") +
              "${widget.plan}",
          buttons: [
            DialogButton(
              child: Text(
                el.tr("Ok"),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    _getCurrentUser();
    _getpastPurchases();
    initNotifications(setState: setState, context: context);
    initSocket(appStore);
    appController.getMatches();
    appController.getNotifications();

    Rks.update_current_user = _getCurrentUser;
    Rks.callApiForYou = query;
  }

  @override
  void dispose() {
    _subscription!.cancel();
    _tabController.dispose();
    super.dispose();
  }

  _getCurrentUser() async {
    userD.User? user = await Rks.get_current_user();
    _getAccessItems();
    currentUser = user;
    users.clear();
    userRemoved.clear();
    getUserList();
    getLikedByList();
    configurePushNotification(currentUser!);

    _checkTotalScoreAndShowDialog();

    if (mounted) setState(() {});
    return currentUser;
  }

  double parseTotalScore(String? scoreString) {
    if (scoreString == null) return 0.0;
    try {
      return double.tryParse(scoreString) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // In TabbarState class
  void _checkTotalScoreAndShowDialog() {
    if (appStore.totalScore != null) {
      try {
        // double score = double.tryParse(appStore.totalScore!) ?? 0.0;
        double score = parseTotalScore(appStore.totalScore);
        if (score <= 5.00) {
          Future.delayed(Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LowScoreDialogue();
              },
            );
          });
        }
      } catch (e) {
        print('Error parsing totalScore: $e');
      }
    }
  }

  void query({String start = "0", limit = "${paginationLimit}"}) async {
    var usersf =
        await getusersmy(userId: currentUser!.id, start: start, limit: limit);

    // Rks.logger.i("${users.map((user) => user.iid.toString()).join(', ')}");

    List<SearchUser> allusers = [];

    usersf.data.forEach((element) async {
      allusers.add(SearchUser.fromJson(element));
    });

    if (allusers.length < 1) {
      print("no more data");
      return;
    }
    allusers = allusers.reversed.toList();
    for (var doc in allusers) {
      users.add(doc);
    }

    if (mounted) setState(() {});
  }

  Future getUserList() async {
    List checkedUser = [];
    getusers(userId: currentUser!.id)
        .then((event) {
      var data = event.data;
      if (data != null) {
        var LikedUser = data['LikedUser'];
        var DislikedUser = data['DislikedUser'];

        if (LikedUser is List) {
          for (var element in LikedUser) {
            if (element is Map<String, dynamic>) {
              checkedUser.add(userD.User.fromJson(element));
            }
          }
        }

        if (DislikedUser is List) {
          for (var element in DislikedUser) {
            if (element is Map<String, dynamic>) {
              checkedUser.add(userD.User.fromJson(element));
            }
          }
        }
      }
    })
        .then((v) async {})
        .catchError((onError) {
      my_print_err(onError);
    });
  }

  getLikedByList() {
    // docRef
    //     .doc(currentUser!.id)
    //     .collection("LikedBy")
    //     .snapshots()
    //     .listen((data) async {
    //   likedByList.addAll(data.docs.map((f) => f['LikedBy']));
    // });
    query();
  }

  int swipecount = 0;

  Map items = {};

  _getAccessItems() async {
    await getItemsAccess().then((res) async {
      if (res.data != null) {
        items = res.data;

        if ((currentUser!.meta!["paid_radius"] ?? 50) > 50) {
          items = {
            ...items,
            ...currentUser!.meta!,
          };
        } else {
          items = {
            ...currentUser!.meta!,
            ...items,
          };
        }
      }
      Rks.items = items;
      if (mounted) setState(() {});
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          PaintingBinding.instance.imageCache.clear();
          CacheManager(Config("")).emptyCache();

          await _verifyPuchase(purchaseDetails.productID);

          break;
        case PurchaseStatus.error:
          print(purchaseDetails.error!);
          break;
        default:
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    });
  }

  Future<void> _getpastPurchases() async {
    bool isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      await _iap.restorePurchases();
    }
  }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere(
      (purchase) => purchase.productID == productId,
    );
  }

  ///verifying pourchase of user
  Future<void> _verifyPuchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      inspect(purchase);
      _sendPurchaseToBackend(purchase, Rks.product!);

      if (Platform.isAndroid) {
        if (purchase.productID == "seeprivate") {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchase);
        }
      }

      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
      }
      isPuchased = true;
    } else {
      isPuchased = false;
    }
  }

  Future<void> _sendPurchaseToBackend(
      PurchaseDetails purchase, ProductDetails product) async {
    var user = {
      'purchaseToken': purchase.verificationData.serverVerificationData,
      'productId': product.id,
      'orderId': purchase.purchaseID,
      'paidalbum': Rks.payingUser!.iid,
      'description': product.description,
      'title': product.title,
      'price': product.price,
      'rawPrice': product.rawPrice,
      'currencyCode': product.currencyCode,
      'currencySymbol': product.currencySymbol,
    };
    await havepurchased(user).then((value) async {
      if (value.data["accesses"]["privates"].contains(Rks.payingUser!.iid)) {
        await Rks.get_current_user();
        Navigator.push(
          Rks.context!,
          CupertinoPageRoute(builder: (context) {
            return GridGalleryPublicTotal(
              showOverlays: false,
              theuser: Rks.payingUser!,
            );
          }),
        );
      }
    }).catchError((e) {});
  }

  configurePushNotification(userD.User user) async {
    // await FirebaseMessaging.instance
    //     .requestPermission(
    //         alert: true, badge: true, sound: true, provisional: false)
    //     .then((value) {
    //   return null;
    // });

    // FirebaseMessaging.instance.getToken().then((token) {
    //   print('token)))))))))$token');
    //   docRef.doc(user.id).update({
    //     'pushToken': token,
    //   });
    // });
    // FirebaseMessaging.instance.

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) async {
    //   print('getInitialMessage data: ${message}');
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("onMessage data: ${message.data}");
    //   print("onmessage${message.data['type']}");

    //   if (Platform.isIOS && message.data['type'] == 'Call') {
    //     Map callInfo = {};
    //     callInfo['channel_id'] = message.data['channel_id'];
    //     callInfo['senderName'] = message.data['senderName'];
    //     callInfo['senderPicture'] = message.data['senderPicture'];
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => Incoming(callInfo)));
    //   } else if (Platform.isAndroid && message.data['type'] == 'Call') {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => Incoming(message.data)));
    //   } else
    //     print("object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    // });

    // // replacement for onResume: When the app is in the background and opened directly from the push notification.
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print('onMessageOpenedApp data: ${message.data}');
    //   if (Platform.isIOS && message.data['type'] == 'Call') {
    //     Map callInfo = {};
    //     callInfo['channel_id'] = message.data['channel_id'];
    //     callInfo['senderName'] = message.data['senderName'];
    //     callInfo['senderPicture'] = message.data['senderPicture'];
    //     bool iscallling = _checkcallState(message.data['channel_id']);
    //     print("=================$iscallling");
    //     if (iscallling) {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => Incoming(message.data)));
    //     }
    //   } else if (Platform.isAndroid && message.data['type'] == 'Call') {
    //     bool iscallling = await _checkcallState(message.data['channel_id']);
    //     print("=================$iscallling");
    //     if (iscallling) {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => Incoming(message.data)));
    //     } else {
    //       print("Timeout");
    //     }
    //   }
    // });
  }

  // _checkcallState(channelId) async {
  //   bool iscalling = await FirebaseFirestore.instance
  //       .collection("calls")
  //       .doc(channelId)
  //       .get()
  //       .then((value) {
  //     return value.data()!["calling"] ?? false;
  //   });
  //   return iscalling;
  // }

  @override
  Widget build(BuildContext context) {
    Rks.context = context;
    Rks.currentUser = currentUser;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: white,
            automaticallyImplyLeading: false,
            title: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.black,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                dividerHeight: 0,
                tabs: [
                  Tab(
                      text: "profile",
                      icon: _buildTabIcon(0, "asset/icons/ic_tab_user.png")),
                  Tab(
                      text: "swipe",
                      icon: _buildTabIcon(1, "asset/icons/ic_swipe_tab.png")),
                  Tab(
                      text: "notifications",
                      icon: _buildTabIcon(
                          2, "asset/icons/ic_notification_tab.png")),
                  Tab(
                      text: "chats",
                      icon: _buildTabIcon(3, "asset/icons/ic_message_tab.png")),
                ]),
          ),
          body: currentUser == null
              ? LoaderWidget()
              : currentUser!.isBlocked!
                  ? BlockUser()
                  : Scaffold(
                      body: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(
                            child: Profile(
                                currentUser!, isPuchased, purchases, items)),
                        Center(
                            child: Swipes(currentUser!, users,
                                isPuchased ? 0 : swipecount, items)),
                        // Center(child: Welcome()),
                        Center(
                            child: NotificationsScreen(
                          currentUser: currentUser!,
                        )),
                        Center(child: HomeScreen(currentUser!)),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                    )),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(el.tr('Exit')),
          content: Text(el.tr('Do you want to exit the app?')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(el.tr('No')),
            ),
            TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text(el.tr('Yes')),
            ),
          ],
        );
      },
    );
    return true;
  }

  Widget _buildTabIcon(int index, String iconPath) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          _tabController.index != index ? gray : blackColor, BlendMode.srcIn),
      child: Image.asset(
        iconPath,
        width: 25,
        height: 25,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      ),
    );
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
