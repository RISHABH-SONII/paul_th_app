import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Information.dart';
import 'package:tharkyApp/Screens/Profile/EditProfile.dart';
import 'package:tharkyApp/Screens/Profile/Posts.dart';
import 'package:tharkyApp/Screens/Profile/settings.dart';
import 'package:tharkyApp/Screens/Profile/super_secrefun_page.dart';
import 'package:tharkyApp/Screens/leaderboard.dart';
import 'package:tharkyApp/Screens/mysecrets.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';

class Profile extends StatefulWidget {
  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;

  Profile(this.currentUser, this.isPuchased, this.purchases, this.items);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final PostCreationState _editProfileState = PostCreationState();

  @override
  void initState() {
    Rks.currencUser = widget.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final profil_url =
        "${BASE_URL}images/${widget.currentUser.imageUrl!.length > 0 ? widget.currentUser.imageUrl![0] : '2'}";

    return Scaffold(
      backgroundColor: white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: white),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: "abc",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: secondryColor,
                      child: Material(
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return Info(widget.currentUser,
                                          widget.currentUser, null, null);
                                    });
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    80,
                                  ),
                                  child: CachedNetworkImage(
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    imageUrl: profil_url,
                                    useOldImageOnUrlChange: true,
                                    placeholder: (context, url) =>
                                        loadingImage(),
                                    errorWidget: (context, url, error) =>
                                        errorImage(),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: white,
                                child: IconButton(
                                    alignment: Alignment.center,
                                    icon: "asset/icons/change_profile.png"
                                        .iconImage2(
                                            size: 30, color: primaryColor),
                                    onPressed: () async {
                                      await _editProfileState.source(context,
                                          onfinish: () {}, isprofile: true);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.currentUser.name != null &&
                          widget.currentUser.dob != null
                      ? "${widget.currentUser.name}, ${((DateTime.now().difference(widget.currentUser.dob!).inDays) / 365.2425).truncate()}"
                      : "",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
                Text(
                  "${widget.currentUser.firstName}  ${widget.currentUser.lastName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
                Text(
                  widget.currentUser.coordinates!['address'] != null
                      ? "${widget.currentUser.coordinates!['address']}"
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: black, fontWeight: FontWeight.w400, fontSize: 15),
                ),
                SizedBox(height: height/18),
                Container(
                  height: height / 2.5,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                splashColor: secondryColor,
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: "asset/icons/ic_setting.png"
                                    .iconImage2(size: 30, color: black),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          maintainState: true,
                                          builder: (context) => Settings(
                                              widget.currentUser,
                                              widget.isPuchased,
                                              widget.items)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Settings".tr().toString(),
                                style: boldTextStyle(color: blackColor),
                              ),
                            )
                          ],
                        ),
                      ).paddingOnly(left: 30, top: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                splashColor: secondryColor,
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: "asset/icons/my_posts.png"
                                    .iconImage2(size: 20, color: black),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostCreation(
                                              widget.currentUser)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "My Pix".tr().toString(),
                                style: boldTextStyle(color: blackColor),
                              ),
                            )
                          ],
                        ),
                      ).paddingOnly(
                          left: MediaQuery.of(context).size.width * .43,
                          top: 20),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Column(
                      //     children: <Widget>[
                      //       Container(
                      //         height: 58,
                      //         width: 58,
                      //         child: FloatingActionButton(
                      //             heroTag: UniqueKey(),
                      //             splashColor: secondryColor,
                      //             backgroundColor: white,
                      //             child: "asset/icons/add_camera.png"
                      //                 .iconImage2(
                      //                     size: 90, color: primaryColor),
                      //             onPressed: () {
                      //               bool canUploadPhotos = false;
                      //               if (!canUploadPhotos) {
                      //                 showToast(
                      //                     "Please Upgrade your plan to upload more pictures ! ",
                      //                     context: context,
                      //                     animation: StyledToastAnimation
                      //                         .slideFromLeft,
                      //                     reverseAnimation:
                      //                         StyledToastAnimation.slideToTop,
                      //                     fullWidth: true,
                      //                     position: StyledToastPosition.top,
                      //                     animDuration: Duration(seconds: 1),
                      //                     duration: Duration(seconds: 4),
                      //                     curve: Curves.elasticOut,
                      //                     reverseCurve: Curves.linear,
                      //                     textStyle:
                      //                         TextStyle(color: whiteColor),
                      //                     backgroundColor: blackColor);
                      //               } else {
                      //                 _editProfileState.source(context);
                      //               }
                      //             }),
                      //       ),
                      //       Text(
                      //         "create".tr().toString(),
                      //         style: boldTextStyle(color: blackColor),
                      //       ).paddingAll(8),
                      //     ],
                      //   ),
                      // ).paddingOnly(
                      //     right: MediaQuery.of(context).size.width * .30,
                      //     top: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              splashColor: secondryColor,
                              backgroundColor: Colors.white,
                              child: "asset/icons/edit_profile.png"
                                  .iconImage2(size: 90, color: black),
                              onPressed: () async {
                                final result = await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            EditProfile(widget.currentUser)));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Info".tr().toString(),
                                style: boldTextStyle(color: blackColor),
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(right: 30, top: 30),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              splashColor: secondryColor,
                              backgroundColor: Colors.white,
                              child: "asset/icons/ic_ranking.png"
                                  .iconImage2(size: 30, color: black),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            LeaderboardPage()));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Leader Board".tr().toString(),
                                style: boldTextStyle(color: blackColor),
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(
                        top: 127,
                        right: 200,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              splashColor: secondryColor,
                              backgroundColor: Colors.white,
                              child: "asset/icons/ic_ranking.png"
                                  .iconImage2(size: 30, color: black),
                              onPressed: () async {
                                // commonLaunchUrl(DOMAIN_URL);

                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MyWallet()));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "My Wallet".tr().toString(),
                                style: boldTextStyle(color: blackColor),
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(
                        top: 127,
                        left: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width * .85,
                              child: Container(
                                decoration:
                                    boxDecorationDefault(color: blackColor),
                                child: Image.asset(
                                  "asset/applogo.jpg",
                                  fit: BoxFit.fill,
                                ),
                              )

                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(10),
                              //   child: Swiper(
                              //     key: UniqueKey(),
                              //     curve: Curves.linear,
                              //     autoplay: true,
                              //     physics: ScrollPhysics(),
                              //     itemBuilder:
                              //         (BuildContext context, int index2) {
                              //       return Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: <Widget>[
                              //             Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: <Widget>[
                              //                 Icon(
                              //                   adds[index2]["icon"],
                              //                   color: adds[index2]["color"],
                              //                 ),
                              //                 SizedBox(
                              //                   width: 5,
                              //                 ),
                              //                 Text(
                              //                   adds[index2]["title"],
                              //                   textAlign: TextAlign.center,
                              //                   style: TextStyle(
                              //                       fontSize: 20,
                              //                       fontWeight: FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //             Text(
                              //               adds[index2]["subtitle"],
                              //               textAlign: TextAlign.center,
                              //             ),
                              //           ]);
                              //     },
                              //     itemCount: adds.length,
                              //     pagination: new SwiperPagination(
                              //         alignment: Alignment.bottomCenter,
                              //         builder: DotSwiperPaginationBuilder(
                              //             activeSize: 10,
                              //             color: secondryColor,
                              //             activeColor: primaryColor)),
                              //     control: new SwiperControl(
                              //       size: 20,
                              //       color: primaryColor,
                              //       disableColor: secondryColor,
                              //     ),
                              //     loop: false,
                              //   ),
                              // ),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height/10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor
                                ])),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          widget.isPuchased
                              ? "Check Payment Details".tr().toString()
                              : "super secret fun page".tr().toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      if (widget.isPuchased) {
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //       builder: (context) =>
                        //           PaymentDetails(widget.purchases)),
                        // );
                      } else {
                        SuperSecretFunPage().launch(context);
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //       builder: (context) => Subscription(
                        //           widget.currentUser, null, widget.items)),
                        // );
                      }
                      // showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return Dialog(
                      //         insetAnimationDuration: Duration(seconds: 3),
                      //         elevation: 25,
                      //         insetPadding: EdgeInsets.all(20),
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20)),
                      //         insetAnimationCurve: Curves.bounceInOut,
                      //         backgroundColor: Colors.white,
                      //         child: Subscription(),
                      //       );
                      //    });
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondryColor.withOpacity(.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
