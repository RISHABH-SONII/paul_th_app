import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Chat/Matches.dart';
import 'package:tharkyApp/Screens/Chat/chatPage.dart';
import 'package:tharkyApp/Screens/Chat/largeImage.dart';
import 'package:tharkyApp/Screens/Information.dart';
import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/models/user_model.dart';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:animate_do/animate_do.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:tharkyApp/utils/videoPlayer.dart';

Widget likeIt(
    {type = "like",
    String? username,
    User? user1,
    User? user2,
    BuildContext? context,
    Room? room}) {
  switch (type) {
    case "like":
      return _buildLabel("LIKE", Colors.lightBlueAccent, -pi / 8);
    case "nope":
      return _buildLabel("NOPE", Colors.red, pi / 8);
    case "match":
      return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomIn(
                    duration: Duration(milliseconds: 600),
                    child: Text(
                      "It's a Match!",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BounceInLeft(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              NetworkImage(imageUrl(user1!.imageUrl![0])!),
                        ),
                      ),
                      SizedBox(width: 20),
                      BounceInRight(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              NetworkImage(imageUrl(user2!.imageUrl![0])!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        simulateScreenTap();
                        Navigator.push(
                            context!,
                            CupertinoPageRoute(
                                builder: (context) => ChatPage(
                                      sender: user1,
                                      second: user2,
                                      room: room!,
                                    )));
                      },
                      child: Text(
                        "Say Hello!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    delay: Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: () {
                        simulateScreenTap();
                      },
                      child: Text(
                        "Keep Swiping",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    default:
      return Container(); // Fallback widget if type is invalid
  }
}

Widget _buildLabel(String text, Color color, double angle) {
  return Align(
    alignment: angle < 0 ? Alignment.topLeft : Alignment.topRight,
    child: Transform.rotate(
      angle: angle,
      child: Container(
        height: 80,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 2, color: color),
        ),
        child: Center(
          child: Text(text.tr(),
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 32)),
        ),
      ),
    ),
  );
}

Widget startNewDiscussion() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.chat_bubble_outline,
          size: 80,
          color: Colors.blueAccent, // Adjust icon color
        ),
        SizedBox(height: 20),
        Text(
          "Start the discussion!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Send a message to begin the conversation.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    ),
  );
}

class SenderMessageWidget extends StatefulWidget {
  final Message message;

  SenderMessageWidget({required this.message});

  @override
  _SenderMessageWidgetState createState() => _SenderMessageWidgetState();
}

class _SenderMessageWidgetState extends State<SenderMessageWidget> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: message.file != ''
                      ? InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: message.type == 'video' ?
                                        FutureBuilder<Uint8List?>(
                                          future: getVideoThumbnail(videoUrl(message.file).toString()),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Container(
                                                height: 200,
                                                child: Center(child: CircularProgressIndicator()),
                                              );
                                            } else if (snapshot.hasData) {
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.memory(
                                                    snapshot.data!,
                                                    width: double.infinity,
                                                    height: 400,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  Icon(Icons.play_circle_fill, size: 48, color: Colors.black87),
                                                ],
                                              );
                                            } else {
                                              return Center(child: Icon(Icons.videocam));
                                            }
                                          },
                                        ) :  CachedNetworkImage(
                                          imageUrl: imageUrl(message.file)!,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 300,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _isTapped =
                                                !_isTapped; // Toggle the tapped state
                                          });
                                          if (message.type == 'video') {
                                            print("image Url issue ::: ${videoUrl(message.file)}");
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) => VideoPlayerScreen(videoUrl: videoUrl(message.file)!),
                                            ));
                                          } else {
                                            Navigator.of(context).push(CupertinoPageRoute(
                                              builder: (context) => LargeImage(imageUrl(message.file)!),
                                            ));
                                          }
                                        },
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        message.content ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          10.width,
                                          message.isRead == false
                                              ? Icon(
                                                  Icons.done,
                                                  color: whiteColor,
                                                  size: 15,
                                                )
                                              : Icon(
                                                  Icons.done_all,
                                                  color: whiteColor,
                                                  size: 15,
                                                )
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ).withWidth(MediaQuery.of(context).size.width * .85),
                          onTap: () {
                            setState(() {
                              _isTapped = !_isTapped; // Toggle the tapped state
                            });
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTapped = !_isTapped;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          message.content ?? "",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        10.width,
                                        message.isRead == false
                                            ? Icon(
                                                Icons.done,
                                                color: whiteColor,
                                                size: 15,
                                              )
                                            : Icon(
                                                Icons.done_all,
                                                color: whiteColor,
                                                size: 15,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                if (_isTapped)
                  Text(
                    getmesssageDate(message.createdAt),
                    style: TextStyle(
                      color: black,
                      fontSize: 8.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(right: 12),
              ],
            ),
          ),
        ),
      ],
    ).withWidth(MediaQuery.of(context).size.width * .95);
  }
}

class ReceiverMessageWidget extends StatefulWidget {
  final Message message;
  final User sender;
  final User second;
  ReceiverMessageWidget(
      {required this.message, required this.sender, required this.second});

  @override
  _ReceiverMessageWidgetState createState() => _ReceiverMessageWidgetState();
}

class _ReceiverMessageWidgetState extends State<ReceiverMessageWidget> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            10.height,
            InkWell(
              child: CircleAvatar(
                backgroundColor: secondryColor,
                radius: 25.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl(widget.second.imageUrl![0])!,
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) => CupertinoActivityIndicator(
                      radius: 15,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              onTap: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Info(widget.second, widget.sender, null, null);
                  }),
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: message.file != ''
                      ? InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: message.type == 'video'
                                            ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.black12,
                                              child: Icon(Icons.videocam, size: 70, color: Colors.grey),
                                            ),
                                            Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
                                          ],
                                        )
                                            : CachedNetworkImage(
                                          imageUrl: imageUrl(message.file)!,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 300,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _isTapped =
                                                !_isTapped; // Toggle the tapped state
                                          });
                                          if (message.type == 'video') {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) => VideoPlayerScreen(videoUrl: imageUrl(message.file)!),
                                            ));
                                          } else {
                                            Navigator.of(context).push(CupertinoPageRoute(
                                              builder: (context) => LargeImage(imageUrl(message.file)!),
                                            ));
                                          }
                                        },
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        message.content ?? "",
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ).withWidth(MediaQuery.of(context).size.width * .85),
                          onTap: () {
                            setState(() {
                              _isTapped = !_isTapped; // Toggle the tapped state
                            });
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTapped = !_isTapped; // Toggle the tapped state
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            margin:
                                EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          message.content ?? "",
                                          style: TextStyle(
                                            color: blackColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                ),
                if (_isTapped)
                  Text(
                    getmesssageDate(message.createdAt),
                    style: TextStyle(
                      color: black,
                      fontSize: 8.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(right: 12),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: FadeInUp(
            duration: Duration(milliseconds: 600),
            delay: Duration(milliseconds: index * 200),
            child: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}

Widget customIconButton({
  required String text,
  required VoidCallback onPressed,
  IconData icon = Icons.arrow_back,
  double iconSize = 20,
  Color iconColor = Colors.white,
  String? translationKey,
  Color textColor = Colors.white,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w500,
  Color backgroundColor = Colors.black,
  EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  double borderRadius = 12,
  double elevation = 2,
  Color? shadowColor,
  bool animate = false,
  Duration animationDuration = const Duration(milliseconds: 300),
}) {
  return ElevatedButton.icon(
    icon: Icon(
      icon,
      size: iconSize,
      color: iconColor,
    ),
    label: Text(
      translationKey != null ? translationKey.tr() : text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
      shadowColor: shadowColor,
    ),
    onPressed: onPressed,
  );
}

Future<void> waitForArrayData(List<dynamic> data) async {
  while (data.isEmpty) {
    await Future.delayed(Duration(seconds: 2));
  }
}

/// Video view wrapper
Widget videoView(view) {
  return Expanded(child: Container(child: view));
}

/// Video view row wrapper
Widget expandedVideoRow(List<Widget> views) {
  final wrappedViews = views.map<Widget>(videoView).toList();
  return Expanded(
    child: Row(
      children: wrappedViews,
    ),
  );
}

// Add this helper method to format the duration
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}
