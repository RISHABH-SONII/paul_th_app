import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/components/mapc/skeleton.dart';

// import 'package:tharkyApp/Screens/Chat/Matches.dart';
import 'package:tharkyApp/components/videoplayer.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:tharkyApp/utils/utls.dart';

class PostInformation extends StatefulWidget {
  final bool isVideo;
  final String mediaId;
  final play;

  PostInformation(
      {required this.isVideo, required this.mediaId, Key? key, this.play})
      : super(key: key);

  @override
  _PostInformationState createState() => _PostInformationState();
}

class _PostInformationState extends State<PostInformation> {
  dynamic media = {};
  bool isLoading = true;
  bool isFullScreen = false; // Pour gérer l'état du mode plein écran

  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  Future _getMedia() async {
    if (widget.mediaId != 0) {
      setState(() {
        isLoading = true;
      });
      await gepost(id: "${widget.mediaId}").then((res) async {
        media = res;
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      showDialog(
          context: context,
          barrierColor: Colors.black, // Optional: to make the background black
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: Colors.black, // Fullscreen background color
              body: Center(
                child: GestureDetector(
                  onTap: _toggleFullScreen, // Tap to exit fullscreen
                  child: !widget.isVideo
                      ? CachedNetworkImage(
                          imageUrl: imageUrl(widget.mediaId)!,
                          fit: BoxFit
                              .contain, // Use 'contain' to fit the image within the screen
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(
                            radius: 20,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : VideoPlayerWidget(
                          videoUrl: videoUrl(widget.mediaId)!,
                          play: widget.play,
                        ),
                ),
              ),
            );
          }).then((_) {
        setState(() {
          isFullScreen =
              false; // Reset the fullscreen state when the dialog is closed
        });
      });
    } else {
      // If not in fullscreen, you can optionally handle other logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Center(
                            heightFactor: 1,
                            child: !widget.isVideo
                                ? Hero(
                                    tag: "abc",
                                    child: GestureDetector(
                                      onTap: _toggleFullScreen,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl(widget.mediaId)!,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        useOldImageOnUrlChange: true,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                          radius: 20,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : VideoPlayerWidget(
                                    videoUrl: videoUrl(widget.mediaId)!,
                                    play: widget.play),
                          ),
                        ),
                        if (!isFullScreen)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: isLoading
                                    ? [
                                        Skeleton(
                                          width: 50,
                                        ).paddingOnly(bottom: 10),
                                      ]
                                    : [
                                        IconButton(
                                          icon: Column(
                                            children: [
                                              Icon(
                                                Icons.fullscreen,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            _toggleFullScreen();
                                          },
                                        ),
                                      ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isFullScreen)
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: isLoading
                                ? [
                                    Skeleton(
                                      width: 50,
                                    ).paddingOnly(bottom: 10),
                                    Skeleton(
                                      width: 50,
                                    ).paddingOnly(bottom: 10),
                                    Skeleton(
                                      width: 50,
                                    ).paddingOnly(bottom: 10),
                                    Skeleton(
                                      width: 50,
                                    ).paddingOnly(bottom: 10),
                                  ]
                                : [
                                    IconButton(
                                      icon: Column(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          Text("${media.likedBy?.length ?? 0}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      onPressed: () async {},
                                    ),
                                    IconButton(
                                      icon: Column(
                                        children: [
                                          Icon(
                                            Icons.heart_broken,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          Text(
                                              "${media.dislikedBy?.length ?? 0}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      onPressed: () async {},
                                    ),
                                    IconButton(
                                      icon: Column(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          Text(
                                              "${media.superlikes?.length ?? 0}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      onPressed: () async {},
                                    ),
                                  ],
                          ),
                          ListTile(
                            trailing: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: primaryColor,
                                )),
                          ),
                          isLoading
                              ? Column(
                                  children: List.generate(1, (i) {
                                  return const ListTile(
                                    title: FractionallySizedBox(
                                      widthFactor: .5,
                                      alignment: Alignment.centerLeft,
                                      child: Skeleton(),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: FractionallySizedBox(
                                        widthFactor: .9,
                                        alignment: Alignment.centerLeft,
                                        child: Skeleton(
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                    horizontalTitleGap: 0,
                                    contentPadding: EdgeInsets.zero,
                                  );
                                })).paddingAll(20)
                              : ListTile(
                                  dense: true,
                                  title: Text(
                                    "${media.title ?? "Glitter Overload Alert!"}",
                                    style: boldTextStyle(size: 30),
                                  ).tr(),
                                  subtitle: Text(
                                    "${media.description ?? """The real challenge starts when you attempt to define your style. One day you're channeling your inner "boho chic" goddess, and the next, you're "street style" vibes with a side of "I’ve-given-up." Oh, and let’s not forget that in the age of online shopping, half of our wardrobe is filled with clothes we never try on—because we’re optimistic that one day, somehow, we’ll fit into them. Spoiler: we won’t. But at least it was on sale, right?"""}",
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ],
                      ).paddingOnly(bottom: 50),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
