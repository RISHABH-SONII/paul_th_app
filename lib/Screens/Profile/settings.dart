import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/Screens/UpdateLocation.dart';
import 'package:tharkyApp/Screens/auth/login.dart';
import 'package:tharkyApp/ads/ads.dart';
import 'package:tharkyApp/components/mapc/autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/country_list_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';

class Settings extends StatefulWidget {
  final User currentUser;
  final bool isPurchased;
  final Map items;

  Settings(this.currentUser, this.isPurchased, this.items);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic> editInfo = {};

  late RangeValues ageRange;
  var _showMe;
  late int distance;

  // Ads _ads = new Ads();
  // late BannerAd _ad;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  late AdWidget adWidget;

  final AdSize adSize = AdSize(height: 300, width: 50);

  @override
  void dispose() {
    // _ads.disable(_ad);
    myBanner.dispose();
    // _ad?.dispose();
    super.dispose();

    if (editInfo.length > 0) {
      updateData();
    }
  }

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  Future updateData() async {
    print('---------------------${widget.currentUser.id}');
    if (editInfo.isEmpty) {
      return;
    }
    try {
      setState(() {
        appStore.setLoading(true);
      });
    } catch (e) {}
    final user = User(
      coordinates:
          editInfo.containsKey("coordinates") ? editInfo["coordinates"] : null,
      gender: editInfo.containsKey("gender") ? editInfo["gender"] : null,
      showGender:
          editInfo.containsKey("showGender") ? editInfo["showGender"] : null,
      ageRange:
          editInfo.containsKey("age_range") ? editInfo["age_range"] : null,
      maxDistance:
          editInfo.containsKey("maxDistance") ? editInfo["maxDistance"] : null,
    );

    await editsettings(user.toJson()).then((value) async {
      saveUserData(value.data!);
      Rks.update_current_user();

      editInfo = {};
    }).catchError((e) {
      myprint2(e);
    });
    try {
      setState(() {
        appStore.setLoading(false);
      });
    } catch (e) {}
  }

  late int freeR;
  late int paidR;

  @override
  void initState() {
    // _ad = _ads.myBanner();
    adWidget = AdWidget(ad: myBanner);

    super.initState();
    myBanner.load();
    freeR = widget.items['free_radius'] != null
        ? (widget.items['free_radius'])
        : 400;
    paidR = widget.items['paid_radius'] != null
        ? (widget.items['paid_radius'])
        : 400;
    setState(() {
      if (!widget.isPurchased && widget.currentUser.maxDistance! > freeR) {
        widget.currentUser.maxDistance = freeR.round();
        editInfo.addAll({'maxDistance': freeR.round()});
      } else if (widget.isPurchased &&
          widget.currentUser.maxDistance! >= paidR) {
        widget.currentUser.maxDistance = paidR.round();
        editInfo.addAll({'maxDistance': paidR.round()});
      }
      _showMe = widget.currentUser.showGender;
      _showMe = _showMe == "" ? "man" : _showMe;

      distance = widget.currentUser.maxDistance!.round() == 0
          ? 1
          : widget.currentUser.maxDistance!.round();

      ageRange = RangeValues(
          double.parse("${(widget.currentUser.ageRange!['min']) ?? "20"}"),
          (double.parse("${(widget.currentUser.ageRange!['max']) ?? "50"}")));
    });
  }

  final TextEditingController _confirmController = TextEditingController();
  bool _showInputField = false;
  bool _isButtonEnabled = false;

  void _handleConfirmChange(String value) {
    setState(() {
      _isButtonEnabled = value.trim().toUpperCase() == 'DELETE';
    });
  }

  void _deleteAccount() {
    if (_isButtonEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully.'),
          backgroundColor: Colors.red,
        ),
      );
      // Add your account deletion logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: Text(
            "Settings".tr().toString(),
            style: TextStyle(color: blackColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: blackColor,
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: whiteColor),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   alignment: Alignment.center,
              //   child: adWidget,
              //   width: myBanner.size.width.toDouble(),
              //   height: myBanner.size.height.toDouble(),
              // ),
              Text(
                "Discovery settings".tr().toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ).paddingOnly(left: 18, bottom: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  color: Colors.grey.shade200,
                  child: ExpansionTile(
                    key: UniqueKey(),
                    backgroundColor: Colors.grey.shade200,
                    title: Row(
                      children: [
                        Text(
                          "Current location : ".tr().toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        10.width,
                        Expanded(
                          child: Text(
                            widget.currentUser.coordinates!['address'] ??
                                "No address available",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                              size: 25,
                            ),
                            InkWell(
                              child: Text(
                                "Change location".tr().toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                var address = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateLocation(),
                                  ),
                                );

                                try {} catch (e) {}

                                if (address is MapBoxPlace) {
                                  editInfo['coordinates'] = {
                                    'latitude': address.lat,
                                    'longitude': address.lon,
                                    'address': address.placeName,
                                  };
                                } else if (address is Map) {
                                  editInfo['coordinates'] = {
                                    'latitude': address['latitude'] ?? '0',
                                    'longitude': address['longitude'] ?? '0',
                                    'placeName': address['PlaceName'] ?? '',
                                    'address': address['PlaceName'] ?? '',
                                  };
                                  if (address['PlaceName'] == null) {
                                    editInfo['coordinates'] = {
                                      'latitude': address['latitude'] ?? '0',
                                      'longitude': address['longitude'] ?? '0',
                                      'address': address['address'] ?? '',
                                    };
                                  }
                                } else {
                                  Rks.logger.f('Unexpected address type');
                                }

                                if (address != null) {
                                  _updateAddress(editInfo['coordinates']);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Change your location to see members in other city"
                    .tr()
                    .toString(),
                style: TextStyle(color: Colors.black54),
              ).paddingOnly(left: 22),
              10.height,

              Card(
                color: Colors.grey.shade200,
                child: ListTile(
                  title: Text(
                    "Maximum distance".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: blackColor,
                        fontWeight: FontWeight.w500),
                  ).paddingOnly(top: 18),
                  trailing: Text(
                    "$distance Km.",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Slider(
                      value: distance.toDouble(),
                      inactiveColor: secondryColor,
                      min: 1.0,
                      max: 12500,
                      activeColor: blackColor,
                      onChanged: (val) {
                        editInfo.addAll({'maxDistance': val.round()});
                        setState(() {
                          distance = val.round();
                        });
                      }),
                ),
              ).paddingAll(12),
              Card(
                color: Colors.grey.shade200,
                child: ListTile(
                  title: Text(
                    "Age range".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: blackColor,
                        fontWeight: FontWeight.w500),
                  ).paddingOnly(top: 18),
                  trailing: Text(
                    "${ageRange.start.round()}-${ageRange.end.round()}",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: RangeSlider(
                      inactiveColor: secondryColor,
                      values: ageRange,
                      min: 18.0,
                      max: 100.0,
                      divisions: 25,
                      activeColor: blackColor,
                      labels: RangeLabels('${ageRange.start.round()}',
                          '${ageRange.end.round()}'),
                      onChanged: (val) {
                        editInfo.addAll({
                          'age_range': {
                            'min': '${val.start.truncate()}',
                            'max': '${val.end.truncate()}'
                          }
                        });
                        setState(() {
                          ageRange = val;
                        });
                      }),
                ),
              ).paddingAll(12),
              // ListTile(
              //   title: Text(
              //     "App settings".tr().toString(),
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              //   ),
              //   subtitle: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: <Widget>[
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Text(
              //               "Notifications".tr().toString(),
              //               style: TextStyle(
              //                   fontSize: 18,
              //                   color: primaryColor,
              //                   fontWeight: FontWeight.w500),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Text("Push notifications".tr().toString()),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                child: StreamBuilder<List<CountryListResponse>>(
                  stream: fetchLanguages(userId: 1).asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(''),
                      );
                    }
                    return Column(
                      children: snapshot.data!.map((document) {
                        return ListTile(
                          subtitle: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text(
                                      "Change Language".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            "English".tr().toString(),
                                            style:
                                                TextStyle(color: Colors.pink),
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Change Language"
                                                      .tr()
                                                      .toString()),
                                                  content: Text(
                                                      'Do you want to change the language to English?'
                                                          .tr()
                                                          .toString()),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text(
                                                          'No'.tr().toString()),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        EasyLocalization.of(
                                                                context)!
                                                            .setLocale(Locale(
                                                                'en', 'US'));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Tabbar(null,
                                                                        false)));
                                                      },
                                                      child: Text('Yes'
                                                          .tr()
                                                          .toString()),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Spanish".tr().toString(),
                                            style:
                                                TextStyle(color: Colors.pink),
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Change Language"
                                                      .tr()
                                                      .toString()),
                                                  content: Text(
                                                      'Do you want to change the language to Spanish?'
                                                          .tr()
                                                          .toString()),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text(
                                                          'No'.tr().toString()),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        EasyLocalization.of(
                                                                context)!
                                                            .setLocale(Locale(
                                                                'es', 'ES'));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Tabbar(null,
                                                                        false)));
                                                        //                _ads.disable(_ad);
                                                      },
                                                      child: Text('Yes'
                                                          .tr()
                                                          .toString()),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(
                          child: Icon(Icons.share),
                        ),
                      ),
                    ),
                    onTap: () {
                      Share.share(
                          'check out my website https://thenastycollectorsnastycollection.com',
                          //Replace with your dynamic link and msg for invite users
                          subject: 'Look what I made!'.tr().toString());
                    },
                  ),
                  InkWell(
                    child: Card(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.logout,
                              color: redColor,
                            )),
                      ),
                    ),
                    onTap: () async {
                      await logout(context).whenComplete(() {});
                      //           _ads.disable(_ad);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Deleting your account will remove all of your information from our database. This cannot be undone. but we keep your mobile number and email to ensure once blocked/banned you cannot create a new account with the same number or email.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20),
                  if (_showInputField)
                    TextField(
                      controller: _confirmController,
                      onChanged: _handleConfirmChange,
                      decoration: const InputDecoration(
                        labelText: 'Type "DELETE" to confirm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  if (_showInputField)
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _showInputField = false;
                        });
                      },
                      child: Text('Cancel'.tr().toString()),
                    ).center(),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: redColor,
                        ),
                        Text(
                          "Delete Account".tr().toString(),
                          style: TextStyle(
                              color: redColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    onTap: () async {
                      if (_showInputField && _isButtonEnabled) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Account'.tr().toString()),
                              content: Text(
                                  'Do you want to delete your account?'
                                      .tr()
                                      .toString()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('No'.tr().toString()),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final User user = widget.currentUser;
                                    await _deleteUser(user).then((_) async {
                                      await clearPreferences().whenComplete(() {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Login()),
                                        );
                                      });
                                      //         _ads.disable(_ad);
                                    });
                                  },
                                  child: Text('Yes'.tr().toString()),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        setState(() {
                          _showInputField = true;
                        });
                      }
                    },
                  )
                ],
              ).paddingSymmetric(horizontal: 50, vertical: 20),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 100,
                        child: Image.asset(
                          "asset/tharky.png",
                          fit: BoxFit.contain,
                        )),
                  )),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateAddress(Map _address) {
    Rks.logger.f(_address);

    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: <Widget>[
                Material(
                  color: whiteColor,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New address:'.tr().toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ).paddingTop(10),
                    subtitle: Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _address['address'] ?? 'd',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none),
                        ).paddingOnly(left: 15),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Colors.white), // Set background color
                  ),
                  child: Text(
                    "Confirm".tr().toString(),
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () async {
                    simulateScreenTap();
                    await updateData().whenComplete(() => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              widget.currentUser.address =
                                  _address['PlaceName'];
                            });
                            simulateScreenTap();
                          });
                          return Center(
                              child: Container(
                                  width: 160.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: <Widget>[
                                      "asset/icons/ic_ok.png"
                                          .iconImage2(size: 60, color: black),
                                      Text(
                                        "location\nchanged".tr().toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 20),
                                      )
                                    ],
                                  )));
                        }));
                  },
                )
              ],
            ),
          );
        });
  }

  Future _deleteUser(User user) async {
    await deleteAccountCompletely().then((value) async {
      saveUserData(value.data!);
      Rks.update_current_user();

      editInfo = {};
    }).catchError((e) {
      myprint2(e);
      // toast(e.toString());
    });
  }
}
