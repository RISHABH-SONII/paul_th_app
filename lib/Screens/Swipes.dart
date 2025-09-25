import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:nb_utils/nb_utils.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tharkyApp/Screens/Information.dart';

// import 'package:tharkyApp/Screens/Payment/subscriptions.dart';
import 'package:tharkyApp/components/CustomRatingWidget.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/components/copole2.dart';
import 'package:tharkyApp/components/item_video.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/searchuser_model.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/swipe_stack.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:video_player/video_player.dart';

import 'Tab.dart';

List userRemoved = [];
int countswipe = 1;

class Swipes extends StatefulWidget {
  final List<SearchUser> users;
  final User currentUser;
  final int swipedcount;
  final Map items;

  Swipes(this.currentUser, this.users, this.swipedcount, this.items);

  @override
  _SwipesState createState() => _SwipesState();
}

class _SwipesState extends State<Swipes>
    with AutomaticKeepAliveClientMixin<Swipes> {
  int startingPositionIndex = 0;
  int position = 0;
  int focusedIndex = 0;
  double currentRating = 0;
  bool isLoading = false;
  Map<String, VideoPlayerController> controllers =
      new Map<String, VideoPlayerController>(); // Make it non-nullable

  bool onEnd = false;

  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();

  bool get wantKeepAlive => true;

  void initState() {
    startingPositionIndex = 1;
    initVideoPlayer();

    super.initState();
  }

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controllers.forEach((key, value) async {
        await value.dispose();
      });
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    int freeSwipe = widget.items['free_swipes'] ?? 10;
    bool exceedSwipes = widget.swipedcount >= freeSwipe;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/swipes.bg.webp'),
            // Replace with your image path
            fit: BoxFit.fitHeight, // Adjust the image's scaling behavior
          ),
        ),
        child: ClipRRect(
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: exceedSwipes,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor.withOpacity(.1),
                      ),
                      height: MediaQuery.of(context).size.height * .78,
                      width: MediaQuery.of(context).size.width,
                      child:
                          //onEnd ||
                          widget.users.length == 0
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.all(100),
                                          child: Image.asset(
                                            "asset/tharky.png",
                                            fit: BoxFit.contain,
                                          )),
                                      Text(
                                        "There's no one new around you."
                                            .tr()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: black,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                )
                              : SwipeStack(
                                  key: swipeKey,
                                  children: widget.users
                                      .mapIndexed((index, useryousee) {
                                    var theres = useryousee.images![0];
                                    var isVideo = isVideofed("${theres}"),
                                        thecorectUrl = isVideo
                                            ? theres
                                            : imageUrl(theres)!;
                                    myprint(thecorectUrl);
                                    if (isVideo &&
                                        !controllers.containsKey(theres)) {
                                      controllers[theres] =
                                          VideoPlayerController.networkUrl(
                                              Uri.parse(videoUrl(theres)!))
                                            ..setLooping(true);
                                    }

                                    return SwiperItem(builder:
                                        (SwiperPosition position,
                                            double progress) {
                                      return Material(
                                          elevation: 5,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          child: Container(
                                            child: Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  child: Swiper(
                                                    customLayoutOption:
                                                        CustomLayoutOption(
                                                      stateCount: 0,
                                                      startIndex: 0,
                                                    ),
                                                    key: UniqueKey(),
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index2) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'asset/hookup4u-Logo-BW.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .78,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: isVideo
                                                            ? ItemVideo(
                                                                videoUrl:
                                                                    thecorectUrl,
                                                                videoPlayerController:
                                                                    controllers[
                                                                        useryousee
                                                                            .images![0]])
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    thecorectUrl,
                                                                fit: BoxFit
                                                                    .cover,
                                                                useOldImageOnUrlChange:
                                                                    true,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    CupertinoActivityIndicator(
                                                                  radius: 20,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                              ),
                                                      );
                                                    },
                                                    itemCount: 1,
                                                    loop: false,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      48.0),
                                                  child: position.toString() ==
                                                          "SwiperPosition.Left"
                                                      ? likeIt(type: 'nope')
                                                      : position.toString() ==
                                                              "SwiperPosition.Right"
                                                          ? likeIt(type: 'like')
                                                          : Container(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ListTile(
                                                              onTap: () {
                                                                showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Info(
                                                                          useryousee
                                                                              as User,
                                                                          widget
                                                                              .currentUser,
                                                                          swipeKey,
                                                                          useryousee
                                                                              .isMatchedWithUser);
                                                                    });
                                                              },
                                                              title: Row(
                                                                children: [
                                                                  Text(
                                                                    // "${index.name}, ${index.about!['showMyAge'] != null ? !index.about!['showMyAge'] ? index.dob : "" : index.dob}",
                                                                    getEllipsisText(
                                                                        "${useryousee.name}, ${getAge(useryousee.dob!)}"),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  5.width,
                                                                  "asset/icons/verified.png"
                                                                      .iconImage2(
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Color(0xFF1D9BF0))
                                                                ],
                                                              ),
                                                              subtitle: Text(
                                                                getEllipsisText(
                                                                    "${useryousee.about}"),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                              )),
                                                          SizedBox(
                                                                  child: AsymmetricTagList(
                                                                      tags: useryousee
                                                                          .interests!))
                                                              .paddingOnly(
                                                                  left: 16,
                                                                  bottom: 20,
                                                                  right: 12),
                                                          CustomRatingWidget(
                                                            initialRating:
                                                                3.5, // Set the initial rating
                                                            onRatingChanged:
                                                                (value) {
                                                              currentRating =
                                                                  value;
                                                              ratethePost(
                                                                  theres,
                                                                  value:
                                                                      currentRating);
                                                            },
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ));
                                    });
                                  }).toList(growable: true),
                                  threshold: 30,
                                  maxAngle: 100,
                                  visibleCount: 5,
                                  historyCount: 1,
                                  stackFrom: StackFrom.Top,
                                  translationInterval: 5,
                                  scaleInterval: 0.08,
                                  onSwipe: (int index,
                                      SwiperPosition position) async {
                                    // _adsCheck(countswipe);
                                    User? next = getPrevElement(
                                        widget.users.cast<User>(), index);

                                    if (next != null &&
                                        isVideofed(next.images![0])) {
                                      _playNext(next.images![0]);
                                    }

                                    onPageChanged(index);

                                    if (position == SwiperPosition.Left) {
                                      likeUnlike(widget.users[index] as User,
                                          value: "unlike");
                                    } else if (position ==
                                        SwiperPosition.Right) {
                                      if (likedByList
                                          .contains(widget.users[index].id)) {}

                                      likeUnlike(widget.users[index] as User,
                                          value: "like");
                                    } else
                                      debugPrint("onSwipe $index $position");
                                    if (index < widget.users.length) {
                                      userRemoved.clear();
                                      setState(() {
                                        userRemoved.add(widget.users[index]);
                                        widget.users.removeAt(index);
                                      });
                                    }
                                    currentRating = 0;
                                  },
                                  onRewind:
                                      (int index, SwiperPosition position) {
                                    swipeKey.currentContext!
                                        .dependOnInheritedWidgetOfExactType();
                                    widget.users.insert(index, userRemoved[0]);
                                    setState(() {
                                      userRemoved.clear();
                                    });
                                    debugPrint("onRewind $index $position");
                                    print(widget.users[index].id);
                                  },
                                ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          widget.users.length != 0
                              ? FloatingActionButton(
                                  heroTag: UniqueKey(),
                                  backgroundColor: Colors.white,
                                  shape: CircleBorder(),
                                  child:
                                      "asset/icons/${userRemoved.length > 0 ? "redo" : "not_intersted"}.png"
                                          .iconImage2(
                                              size: 20,
                                              color: userRemoved.length > 0
                                                  ? Colors.amber
                                                  : secondryColor),
                                  onPressed: () {
                                    if (userRemoved.length > 0) {
                                      swipeKey.currentState!.rewind();
                                    }
                                  })
                              : FloatingActionButton(
                                  heroTag: UniqueKey(),
                                  backgroundColor: Colors.white,
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Color(0xFFFEEEE3),
                              shape: CircleBorder(),
                              child: "asset/icons/clear_simple.png"
                                  .iconImage2(size: 20, color: redColor),
                              onPressed: () {
                                if (widget.users.length > 0) {
                                  print("object");
                                  swipeKey.currentState!.swipeLeft();
                                }
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
                                if (widget.users.length > 0) {
                                  swipeKey.currentState!.swipeRight();
                                }
                              }),
                        ],
                      ),
                    ).paddingAll(25),
                  ],
                ),
              ),
              exceedSwipes
                  ? Align(
                      alignment: Alignment.center,
                      child: InkWell(
                          child: Container(
                            color: Colors.white.withOpacity(.3),
                            child: Dialog(
                              insetAnimationCurve: Curves.bounceInOut,
                              insetAnimationDuration: Duration(seconds: 2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .55,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 50,
                                      color: primaryColor,
                                    ),
                                    Text(
                                      "you have already used the maximum number of free available swipes for 24 hrs."
                                          .tr()
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: 120,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Text(
                                      "For swipe more users just subscribe our premium plans."
                                          .tr()
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Subscription(
                            //             null, null, widget.items)));
                          }),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future ratethePost(String mediaId, {value}) async {
    final user = {
      "mediaId": mediaId,
      "value": value,
    };

    await ratethepost(user).then((value) async {}).catchError((e) {});
  }

  Future likeUnlike(User theuser, {value}) async {
    final user = {
      "resourceId": theuser.images![0],
      "like": value,
    };

    await likeunlike(user).then((value) async {
      if (value.data["match"] != null) {
        Future.delayed(Duration(milliseconds: 1700), () async {
          await showDialog(
              context: context,
              builder: (ctx) {
                return likeIt(
                    type: "match",
                    username: theuser.name,
                    user1: widget.currentUser,
                    user2: theuser,
                    room: Room.fromJson(value.data["room"]),
                    context: context);
              });
        });
      }
    }).catchError((e) {});
  }

  void _playNext(String index) {
    controllers.forEach((key, value) {
      if (value.value.isPlaying) {
        value.pause();
      }
    });
    // Rks.logger.f("** ${Rks.videosing![index]} ");
    // myprint(Rks.videosing![index]);

    _stopControllerAtIndex(getRelativeKey(controllers, index, -1));
    _disposeControllerAtIndex(getRelativeKey(Rks.videosing, index, -2));
    _playControllerAtIndex(getRelativeKey(controllers, index, 0));
    // _initializeControllerAtIndex(getRelativeKey(Rks.videosing!, index, 1));
  }

  // void _playPrevious(int index) {
  //   Rks.videosing!.forEach((key, value) {
  //     value.pause();
  //   });
  //   _stopControllerAtIndex(dcl(index + 1, isPrevious: false));
  //   _disposeControllerAtIndex(dcl(index + 2, isPrevious: false));
  //   _playControllerAtIndex(index);
  //   _initializeControllerAtIndex(dcl(index - 1, isPrevious: true));
  // }

  // Future _initializeControllerAtIndex(String index) async {
  //   if (controllers.containsKey(index)) {  final controller = controllers[index];
  //     if (controller != null) {
  //       controller.initialize().then((_) {
  //          setState(() {});
  //        });
  //      }
  //     log('🚀🚀🚀 INITIALIZED $index');
  //   }
  // }

  void _playControllerAtIndex(String? index) {
    // focusedIndex = index;
    if (controllers.containsKey(index)) {
      final controller = controllers[index];

      if (controller != null) {
        controller.initialize().then((_) {
          controller.play();
          setState(() {});
          simulateCenterTap(context);
        });
        // ApiService().increasePostViewCount(mList[index].postId.toString());
      }
    }
  }

  void _stopControllerAtIndex([String? index = ""]) {
    if (controllers.containsKey(index)) {
      final controller = controllers[index];
      if (controller != null) {
        controller.pause();
        controller.seekTo(const Duration());
        log('==================================');
        log('🚀🚀🚀 STOPPED $index');
      }
    }
  }

  void _disposeControllerAtIndex(String? index) {
    if (controllers.containsKey(index)) {
      final controller = controllers[index];
      controller?.dispose();
      if (controller != null) {
        controllers.remove(controller);
      }
      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  void initVideoPlayer() async {
    if (isVideofed(widget.users[0].images![0])) {
      final controller = controllers[widget.users[0].images![0]]!;

      controller.initialize().then((_) {
        controller.play();
        setState(() {});
        simulateCenterTap(context);
      });
    }

    // if (isVideofed(widget.users[position - 1].images![0]) && position >= 0) {
    //   await _initializeControllerAtIndex(position - 1);
    // }
    // if (isVideofed(widget.users[position + 1].images![0])) {
    //   await _initializeControllerAtIndex(position + 1);
    // }
  }

  void onPageChanged(int value) {
    if (value == 3) {
      if (!isLoading) {
        isLoading = !isLoading;
        Rks.callApiForYou(
          start: startingPositionIndex.toString(),
          limit: paginationLimit.toString(),
        ).then((v) async {
          startingPositionIndex += paginationLimit;
          isLoading = !isLoading;
        });
      }
    }
    // if (isVideofed("${widget.users[value].images![0]}")) {
    //   if (value > focusedIndex) {
    //     _playNext(value);
    //   } else {
    //     _playPrevious(value);
    //   }
    // }
  }

  int dcl(int index, {required bool isPrevious}) {
    int step = isPrevious ? -1 : 1;
    int currentIndex = index;

    while (Rks.videosing.containsKey(currentIndex) == false) {
      currentIndex += step;
      if (currentIndex < 0) break; // Avoid negative index for previous keys
    }

    return currentIndex;
  }

// void _loadInterstitialAd() {
//   InterstitialAd.load(
//     adUnitId: AdHelper.interstitialAdUnitId,
//     request: AdRequest(),
//     adLoadCallback: InterstitialAdLoadCallback(
//       onAdLoaded: (ad) {
//         this._interstitialAd = ad;

//         ad.fullScreenContentCallback = FullScreenContentCallback(
//           onAdDismissedFullScreenContent: (ad) {
//             //  _moveToHome();
//           },
//         );

//         _isInterstitialAdReady = true;
//       },
//       onAdFailedToLoad: (err) {
//         print('Failed to load an interstitial ad: ${err.message}');
//         _isInterstitialAdReady = false;
//       },
//     ),
//   );
// }
}
