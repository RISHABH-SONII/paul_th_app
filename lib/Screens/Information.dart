import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Chat/chatPage.dart';
import 'package:tharkyApp/Screens/Profile/EditProfile.dart';
import 'package:tharkyApp/Screens/components/privatepublic.dart';
import 'package:tharkyApp/Screens/reportUser.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/swipe_stack.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';

class Info extends StatelessWidget {
  final User currentUser;
  final User user;

  final GlobalKey<SwipeStackState>? swipeKey;
  final bool? isMatchedWithUser;

  Info(this.user, this.currentUser, this.swipeKey, this.isMatchedWithUser);

  @override
  Widget build(BuildContext context) {
    bool isMe = user.id == currentUser.id;
    var _isBlurred = (Rks.items["accesses"]["privates"] == null) ||
        (!Rks.items["accesses"]["privates"].contains(user.iid));
    // print("LENGTH : ${user.imageUrl!.length}");
    print("LENGTH : ${user.images!.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: user.images != null && user.images!.isNotEmpty
                          ? Swiper(
                              key: UniqueKey(),
                              physics: ScrollPhysics(),
                              controller: SwiperController(),
                              itemBuilder: (BuildContext context, int index2) {
                                // if (user.imageUrl == null || user.imageUrl!.isEmpty) {
                                //   return SizedBox.shrink(); // or fallback UI
                                // }
                                if (user.images == null ||
                                    user.images!.isEmpty) {
                                  return SizedBox.shrink(); // or fallback UI
                                }
                                return Hero(
                                  tag: "abc",
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl(user.images![index2])!,
                                    fit: BoxFit.cover,
                                    useOldImageOnUrlChange: true,
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(
                                      radius: 20,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                );
                              },
                              indicatorLayout: PageIndicatorLayout.COLOR,
                              autoplay: false,
                              // itemCount: user.imageUrl!.length,
                              itemCount: user.images!.length,
                              pagination: SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                  size: 6.0,
                                  // default dot size
                                  activeSize: 8.0,
                                  // slightly larger for the active dot
                                  color: Colors.grey,
                                  activeColor: Colors.white,
                                ),
                              ),
                              control: new SwiperControl(),
                            )
                          : SizedBox.shrink()),

                  // Swiper(
                  //   key: UniqueKey(),
                  //   physics: ScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index2) {
                  //     return Hero(
                  //       tag: "abc",
                  //       child: CachedNetworkImage(
                  //         imageUrl: imageUrl(user.imageUrl![index2])!,
                  //         fit: BoxFit.cover,
                  //         useOldImageOnUrlChange: true,
                  //         placeholder: (context, url) =>
                  //             CupertinoActivityIndicator(
                  //           radius: 20,
                  //         ),
                  //         errorWidget: (context, url, error) =>
                  //             Icon(Icons.error),
                  //       ),
                  //     );
                  //   },
                  //   itemCount: user.imageUrl!.length,
                  //   pagination: new SwiperPagination(
                  //       alignment: Alignment.bottomCenter,
                  //       builder: DotSwiperPaginationBuilder(
                  //           activeSize: 13,
                  //           color: secondryColor,
                  //           activeColor: primaryColor)),
                  //   control: new SwiperControl(
                  //     color: primaryColor,
                  //     disableColor: secondryColor,
                  //   ),
                  //   loop: false,
                  // ),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text("${user.address}"),
                            title: Text(
                              "${user.name} ${user.dob != null ? ", ${getAge(user.dob!)}" : ""}  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: primaryColor,
                                )),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.person, color: blackColor),
                            title: Text(
                              "${user.firstName} ${user.lastName}",
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.interests, color: blackColor),
                            title: Text(
                              "Interests",
                              style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: user.interests?.map((interest) {
                                  return Chip(
                                    label: Text(
                                      interest,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          width: 0,
                                          color: primaryColor.withOpacity(0.3)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  );
                                }).toList() ??
                                [],
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(Icons.home, color: blackColor),
                            title: Text(
                              """${"Living in ".tr()} ${user.coordinates!['address']}""",
                              style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  20.height,
                  Text(
                    "${user.about}",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ).paddingSymmetric(horizontal: 16),
                  20.height,
                  if (user.privates!.length > 0)
                    Stack(
                      children: [
                        if (_isBlurred)
                          RichTextWidget(
                            list: [
                              TextSpan(
                                text: "See all",
                                style: secondaryTextStyle(
                                    color: primaryColor, size: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              TextSpan(
                                  text: " for £1",
                                  style: secondaryTextStyle(size: 14)),
                            ],
                          ).center(),
                        GridGalleryPublic(
                          showOverlays: _isBlurred,
                          theuser: user,
                          havemore: user.privates!.length > 9,
                        ).paddingTop(10),
                      ],
                    ),
                  !isMe
                      ? InkWell(
                          onTap: () => showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => ReportUser(
                                    currentUser: currentUser,
                                    seconduser: user,
                                  )),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "REPORT ${user.name}".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: primaryColor),
                                ),
                              )),
                        )
                      : Container(),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            (swipeKey != null && !(isMatchedWithUser ?? false))
                ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Color(0xFFFEEEE3),
                              shape: CircleBorder(),
                              child: "asset/icons/clear_simple.png"
                                  .iconImage2(size: 20, color: redColor),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey!.currentState!.swipeLeft();
                              }),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              shape: CircleBorder(),
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.favorite,
                                color: whiteColor,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey!.currentState!.swipeRight();
                              }),
                        ],
                      ),
                    ),
                  )
                : isMe
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: primaryColor,
                            ),
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        EditProfile(user))))).paddingAll(18)
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ChatPage(
                                            sender: currentUser,
                                            second: user,
                                          )));
                            })).paddingAll(18)
          ],
        ),
      ),
    );
  }
}
