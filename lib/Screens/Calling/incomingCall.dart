//import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tharkyApp/Screens/Calling/call.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

import '../Chat/chatPage.dart';

class Incoming extends StatefulWidget {
  final callInfo;

  Incoming(this.callInfo);

  @override
  _IncomingState createState() => _IncomingState();
}

class _IncomingState extends State<Incoming> with TickerProviderStateMixin {
  bool ispickup = false;
  late AnimationController _controller;

  final player = AudioPlayer(); // Create a player

  @override
  void initState() {
    super.initState();

    player.setAsset('asset/Ignite the Spark.mp3');

    player.play();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    Rks.closeCall = close;
  }

  @override
  void dispose() {
    _controller.dispose();
    // await FlutterRingtonePlayer().stop();
    player.stop(); // Pause but remain ready to play
    ispickup = true;
    super.dispose();
  }

  void close() {
    var user = {
      "meetingID": widget.callInfo['meetingID'],
      "userID": widget.callInfo['caller']
    };
    closeCall(user).then((event) {
      var data = event.data;
      if (data != null) {}
    });
    Future.delayed(Duration(milliseconds: 500), () {
      Get.back();
    });
    appController.callanswer.value = "calling";
  }

  @override
  Widget build(BuildContext context) {
    Rks.context = context;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "Incoming Call",
              style: TextStyle(color: Colors.red),
            ),
          ),
          body: Center(
            child: Obx(() {
              return appController.callanswer.value == "calling"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.callInfo['callType'] == "VideoCall"
                              ? el.tr("Incoming Video Call")
                              : el.tr("Incoming Audio Call"),
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        AnimatedBuilder(
                            animation: CurvedAnimation(
                                parent: _controller, curve: Curves.slowMiddle),
                            builder: (context, child) {
                              return Container(
                                height: MediaQuery.of(context).size.height * .3,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    _buildContainer(150 * _controller.value),
                                    _buildContainer(200 * _controller.value),
                                    _buildContainer(250 * _controller.value),
                                    _buildContainer(300 * _controller.value),
                                    _buildContainer(350 * _controller.value),
                                    Align(
                                        child: Icon(
                                      Icons.phone_android,
                                      size: 44,
                                    )),
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 60,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            60,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: widget.callInfo[
                                                    'senderPicture'] ??
                                                '',
                                            useOldImageOnUrlChange: true,
                                            placeholder: (context, url) =>
                                                loadingImage(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    errorImage(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.callInfo['senderName']} ",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.black,
                              child: Text(
                                el.tr("is calling you ..."),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.green,
                                child: Icon(
                                  "AudioCall" == "VideoCall"
                                      ? Icons.video_call
                                      : Icons.call,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await handleCameraAndMic(
                                      widget.callInfo["callType"]);

                                  //1---> initiation de papa 2
                                  cancelNotificationWithTag();

                                  appController.callanswer.value = "answer";
                                  postAnswer({
                                    "userID": widget.callInfo["caller"],
                                    "meetingID": widget.callInfo["channel_id"],
                                    "answer": "answer"
                                  });
                                  // await FlutterRingtonePlayer().stop();
                                  player.stop();
                                }),
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.red,
                                child: Icon(Icons.clear, color: Colors.white),
                                onPressed: () async {
                                  cancelNotificationWithTag();
                                  await postAnswer({
                                    "userID": widget.callInfo["caller"],
                                    "meetingID": widget.callInfo["channel_id"],
                                    "answer": "decline"
                                  });
                                  close();
                                })
                          ],
                        ).paddingSymmetric(horizontal: 20),
                      ],
                    )
                  : CallPage(
                      callType: widget.callInfo['callType'],
                      other: widget.callInfo['callerobj'],
                    );
            }),
          ),
        ));
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller.value),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
