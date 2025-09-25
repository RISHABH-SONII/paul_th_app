import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Profile/UpdateNumber.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/components/mapc/autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:tharkyApp/components/spin_kit_chasing_dots.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/network_utils.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/snackbar.dart';
import 'package:http/http.dart';
import 'package:tharkyApp/utils/utls.dart';

class EditProfile extends StatefulWidget {
  final User currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = new TextEditingController();
  final TextEditingController lstnctrl = new TextEditingController();
  final TextEditingController emailctrl = new TextEditingController();
  final TextEditingController livingCtlr = new TextEditingController();
  final TextEditingController frstctrl = new TextEditingController();
  final TextEditingController screctrl = new TextEditingController();
  final TextEditingController universityCtlr = new TextEditingController();
  final TextEditingController phoneyCtlr = new TextEditingController();
  TextEditingController dobctlr = new TextEditingController();

  bool showInterests = false;

  var showMe;
  Map editInfo = {};
  // Ads _ads = new Ads();
  // late BannerAd _ad;

  Map testMap = {'edit': 'thanks'};

  @override
  void initState() {
    super.initState();
    aboutCtlr.text = widget.currentUser.about ?? '';
    lstnctrl.text = widget.currentUser.lastName ?? '';
    emailctrl.text = widget.currentUser.email ?? '';
    livingCtlr.text = widget.currentUser.coordinates!["address"] ?? '';
    universityCtlr.text = widget.currentUser.about ?? '';
    frstctrl.text = widget.currentUser.firstName ?? '';
    screctrl.text = widget.currentUser.name ?? '';
    dobctlr.text = DateFormat('dd/MM/yyyy').format(widget.currentUser.dob!);
    phoneyCtlr.text = widget.currentUser.phoneNumber != null
        ? "${widget.currentUser.phoneNumber}"
        : "Verify Now".tr().toString();

    setState(() {
      showMe = widget.currentUser.gender ?? 'woman';
      showInterests = widget.currentUser.showInterests ?? false;
    });
    // _ad = _ads.myBanner();
    // _ad
    //   ..load()
    //   ..show();
  }

  @override
  void dispose() {
    print('-------------------------${editInfo.length}');
    if (editInfo.length > 0) {
      updateData();
    }
    // _ads.disable(_ad);
    appStore.setLoading(false);

    editInfo = {};
    super.dispose();
  }

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

    // myprint(text)
    final user = User(
      about: editInfo.containsKey("about") ? editInfo["about"] : null,
      firstName:
          editInfo.containsKey("firstname") ? editInfo["firstname"] : null,
      lastName: editInfo.containsKey("lastname") ? editInfo["lastname"] : null,
      email: editInfo.containsKey("email") ? editInfo["email"] : null,
      showInterests: editInfo.containsKey("showInterests")
          ? editInfo["showInterests"]
          : null,
      coordinates:
          editInfo.containsKey("coordinates") ? editInfo["coordinates"] : null,
      dob: editInfo.containsKey("user_DOB")
          ? DateTime.parse(editInfo["user_DOB"])
          : null,
      gender: editInfo.containsKey("gender") ? editInfo["gender"] : null,
      interests: editInfo.containsKey("interests")
          ? List<String>.from(editInfo["interests"])
          : null,
    );

    await edituser(user.toJson()).then((value) async {
      saveUserData(value.data!);
      Rks.update_current_user();

      editInfo = {};
    }).catchError((e) {
      myprint2(e);
      // toast(e.toString());
    });
    try {
      setState(() {
        appStore.setLoading(false);
      });
    } catch (e) {}
  }

  Future uploadFile(File? image, User currentUser,
      {delete_id, update_id, onfinish, isprofile = false}) async {
    appStore.setLoading(true);

    var user = {"delete_id": delete_id, "update_id": update_id};

    if (delete_id != null) {
    } else {
      if (!image!.existsSync()) {
        toast("Image is not available", print: true);
        return;
      }

      MultipartRequest multiPartRequest =
          await getMultiPartRequest('upload/image');

      multiPartRequest.files
          .add(await MultipartFile.fromPath("image", image.path));
      if (isprofile) {
        multiPartRequest.fields["profile"] = "set";
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          if (data != null) {
            if ((data as String).isJson()) {
              data = json.decode(data) as Map<String, dynamic>?;
              user["imageId"] = "${data["image"]["_id"]}";
            }
          }
        },
        onError: (error) {
          toast(error.toString(), print: true);
        },
      ).catchError((e) {
        toast(e.toString(), print: true);
      });
    }

    await updateImages(user).then((value) async {
      var updatedList = (value.data as List).map((e) => e.toString()).toList();
      setState(() {
        widget.currentUser.images = updatedList;
      });
      await appStore.setImages(updatedList);
      appStore.setLoading(true);
    }).catchError((e) {
      appStore.setLoading(true);

      // toast(e.toString());
    });

    appStore.setLoading(false);

    if (onfinish != null) {
      onfinish();
    }
    setState(() {});

    // YGlobalKeys.imagesIndexes![1] = [imageId];
  }

  @override
  Widget build(BuildContext context) {
    // Profile _profile = new Profile(widget.currentUser);
    // bool canUploadPhotos = widget.currentUser.level == "standard";
    bool canUploadPhotos = false;

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Edit Profile".tr().toString(),
              style: TextStyle(color: primaryColor),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: primaryColor,
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: white),
        body: Scaffold(
          backgroundColor: white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListBody(
                    mainAxis: Axis.vertical,
                    children: <Widget>[
                      editUserField(
                          title: "First name",
                          textEditingController: frstctrl,
                          placeholder: "Enter your first name",
                          onChanged: (text) {
                            editInfo["firstname"] = text;
                          }),
                      editUserField(
                          title: "Last name",
                          textEditingController: lstnctrl,
                          placeholder: "Enter your last name",
                          onChanged: (text) {
                            editInfo["lastname"] = text;
                          }),
                      editUserField(
                          title: "Email",
                          textEditingController: emailctrl,
                          placeholder: "Enter your email address",
                          onChanged: (text) {
                            editInfo["email"] = text;
                          }),
                      editUserField(
                        title: "Phone Number".tr().toString(),
                        textEditingController: phoneyCtlr,
                        placeholder: "+44 0123456789",
                        type: "verify",
                        onChanged: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    UpdateNumber(widget.currentUser))),
                      ),
                      Text("Verify a phone number to secure your account"
                              .tr()
                              .toString())
                          .paddingOnly(left: 16, bottom: 20),
                      editUserField(
                          title: "Living in",
                          textEditingController: livingCtlr,
                          placeholder: "Add city",
                          type: "place",
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapBoxAutoCompleteWidget(
                                  language: 'en',
                                  closeOnSelect: true,
                                  city: "mapboxApi",
                                  limit: 10,
                                  hint: 'Enter your city name'.tr().toString(),
                                  onSelect: (place) {
                                    setState(() {
                                      livingCtlr.text = place.placeName!;
                                      editInfo["coordinates"] = {
                                        'latitude': place.lat,
                                        'longitude': place.lon,
                                        'address': place.placeName,
                                      };
                                    });
                                  },
                                ),
                              )),
                          onmapTap: (result) {
                            livingCtlr.text = result["coordinates"]["address"];
                            editInfo["coordinates"] = result["coordinates"];
                          }),
                      editUserField(
                        title: "Date of birth",
                        textEditingController: dobctlr,
                        placeholder: "DD/MM/YYYY",
                        type: "date",
                        onChanged: () => showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  child: GestureDetector(
                                    child: CupertinoDatePicker(
                                      backgroundColor: Colors.white,
                                      initialDateTime: DateTime(2000, 10, 12),
                                      onDateTimeChanged: (DateTime newdate) {
                                        setState(() {
                                          dobctlr.text =
                                              newdate.day.toString() +
                                                  '/' +
                                                  newdate.month.toString() +
                                                  '/' +
                                                  newdate.year.toString();
                                          editInfo["user_DOB"] =
                                              newdate.toString();
                                        });
                                      },
                                      maximumYear: 2002,
                                      minimumYear: 1800,
                                      maximumDate: DateTime(2002, 03, 12),
                                      mode: CupertinoDatePickerMode.date,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ));
                            }),
                      ),
                      editUserField(
                          title: "About",
                          textEditingController: aboutCtlr,
                          placeholder: "About you",
                          type: "textarea",
                          onChanged: (text) {
                            editInfo["about"] = text;
                          }),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 10),
                      //   child: ListTile(
                      //     title: Text(
                      //       "I am".tr().toString(),
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 18,
                      //         color: Colors.black87,
                      //       ),
                      //     ),
                      //     subtitle: Padding(
                      //       padding: const EdgeInsets.only(
                      //           top: 10), // Adds spacing above the dropdown
                      //       child: DropdownButtonFormField<String>(
                      //         value: showMe,
                      //         icon: Icon(Icons.arrow_drop_down,
                      //             color: primaryColor),
                      //         decoration: InputDecoration(
                      //           contentPadding: EdgeInsets.symmetric(
                      //               horizontal: 15, vertical: 10),
                      //           filled: true,
                      //           fillColor: Colors.grey[100],
                      //         ),
                      //         dropdownColor: Colors
                      //             .white, // Background color of the dropdown
                      //         items: [
                      //           DropdownMenuItem(
                      //             child: Text(
                      //               "EVERYONE".tr().toString(),
                      //               style: TextStyle(
                      //                   fontSize: 16, color: Colors.black),
                      //             ),
                      //             value: "everyone",
                      //           ),
                      //           DropdownMenuItem(
                      //             child: Text(
                      //               "EVERYONE".tr().toString(),
                      //               style: TextStyle(
                      //                   fontSize: 16, color: Colors.black),
                      //             ),
                      //             value: showMe,
                      //           ),
                      //         ],
                      //         onChanged: (val) {
                      //           editInfo.addAll({'gender': val});
                      //           setState(() {
                      //             showMe = val;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // 10.height,
                      SizedBox(
                        height: 200,
                        child: InterestHorizontalListc(
                          interests: updateInterestList(
                              interestList, widget.currentUser.interests ?? []),
                          onInterestToggle: (Map<String, dynamic> interest) {
                            setState(() {
                              interest['ontap'] = !interest['ontap'];

                              if (interest['ontap']) {
                                if (widget.currentUser.interests!.length <
                                    MAXIMUM_INTERESTS) {
                                  if (!widget.currentUser.interests!
                                      .contains(interest['name'])) {
                                    widget.currentUser.interests!
                                        .add(interest['name']);
                                  }
                                } else {
                                  CustomSnackbar.snackbar(
                                      "select upto ${MAXIMUM_INTERESTS}"
                                          .tr()
                                          .toString(),
                                      context);
                                }
                              } else {
                                widget.currentUser.interests!
                                    .remove(interest['name']);
                              }
                              editInfo.addAll(
                                  {'interests': widget.currentUser.interests});
                            });
                          },
                        ).paddingSymmetric(horizontal: 16),
                      ),
                      ListTile(
                          subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text("Show my interests".tr().toString()),
                              ),
                              Switch(
                                  activeColor: primaryColor,
                                  value: showInterests,
                                  onChanged: (value) {
                                    editInfo.addAll({'showInterests': value});
                                    setState(() {
                                      showInterests = value;
                                    });
                                  })
                            ],
                          ),
                        ],
                      )),
                      50.height,
                      appStore.isLoading
                          ? SpinKitChasingDots(
                              color: primaryColor,
                            )
                          : InkWell(
                              canRequestFocus: canUploadPhotos,
                              enableFeedback: canUploadPhotos,
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(4),
                                      color: primaryColor),
                                  height: 50,
                                  width: 340,
                                  child: Center(
                                      child: Text(
                                    "Save".tr().toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: textColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () async {
                                updateData();
                              },
                            ),
                      50.height
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
