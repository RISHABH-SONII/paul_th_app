import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Calling/call.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/components/copole2.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

class DialCall extends StatefulWidget {
  final User receiver;
  final String callType;
  const DialCall({required this.receiver, required this.callType});

  @override
  _DialCallState createState() => _DialCallState();
}

class _DialCallState extends State<DialCall> {
  bool ispickup = false;
  final AppController appController = Get.find<AppController>();
  Timer? _hideControlsTimer;

  //final db = Firestore.instance;
  @override
  void initState() {
    _hideControlsTimer = Timer(Duration(seconds: 30), () {
      if (appController.callanswer.value == "calling") {
        close();
        appController.callanswer.value = "delayed";
      }
    });

    super.initState();
    Rks.closeCall = closeg;
  }

  @override
  void dispose() async {
    ispickup = true;
    _hideControlsTimer?.cancel();

    super.dispose();
  }

  void close() {
    var user = {
      "meetingID": appController.meeting.value!.id,
      "userID": widget.receiver.iid,
    };

    closeCall(user).then((event) {
      Navigator.pop(context);
    }).catchError((onError) {
      my_print_err(onError);
    });
  }

  void closeg() {
    var user = {
      "meetingID": appController.meeting.value!.id,
      "userID": widget.receiver.iid,
    };
    appController.callanswer.value = "calling";

    closeCall(user).then((event) {
      // Navigator.pop(context);
    }).catchError((onError) {
      my_print_err(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: appController.callanswer.value == "calling"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 100,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                                child: CachedNetworkImage(
                                  width: 200,
                                  height: 200,
                                  imageUrl:
                                      imageUrl(widget.receiver.imageUrl![0])!,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(
                                    radius: 15,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      errorImage(),
                                ),
                              ),
                            ),
                          ),
                          20.height,
                          Text("Calling In progress...",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Text(
                              "${widget.receiver.firstName}  ${widget.receiver.lastName} ",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Flash(
                        infinite: true,
                        duration: const Duration(seconds: 5),
                        child: Icon(
                          widget.callType == "VideoCall"
                              ? Icons.videocam
                              : Icons.phone,
                          color: blackColor,
                          size: 100,
                        ),
                      ),
                      customIconButton(
                          text: el.tr("END"),
                          icon: Icons.call_end,
                          onPressed: () async {
                            close();
                          })
                    ],
                  )
                : appController.callanswer.value == "decline"
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flash(
                            infinite: true,
                            duration: const Duration(seconds: 5),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 60,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        60,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl(
                                            widget.receiver.imageUrl![0])!,
                                        useOldImageOnUrlChange: true,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          radius: 15,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            errorImage(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "${widget.receiver.name} is Busy",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ).tr(),
                              ],
                            ),
                          ),
                          Bounce(
                              infinite: true,
                              from: 10,
                              duration: const Duration(seconds: 1),
                              child: customIconButton(
                                  text: el.tr("Back"),
                                  onPressed: () =>
                                      Navigator.maybePop(context))),
                        ],
                      )
                    : appController.callanswer.value == "delayed"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(" ${widget.receiver.name} is not answering",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))
                                  .tr(args: ["${widget.receiver.name}"]),
                              customIconButton(
                                  text: el.tr("Back"),
                                  icon: Icons.arrow_back,
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  })
                            ],
                          )
                        : CallPage(
                            callType: widget.callType,
                            iscalling: true,
                            other: widget.receiver)),
      );
    });
  }
}
