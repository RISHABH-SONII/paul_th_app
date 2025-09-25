import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Payment/singlepay.dart';
import 'package:tharkyApp/Screens/PostInformation.dart';
import 'package:tharkyApp/Screens/components/privatepubliclytotal.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';

class GridGalleryPublic extends StatelessWidget {
  final bool showOverlays;
  final bool havemore;
  final User theuser;

  GridGalleryPublic(
      {required this.havemore,
      required this.showOverlays,
      required this.theuser});

  List<String> getprivates(List<String> thelist) {
    List<String> _imageList = [];

    if (thelist.length > 9) {
      _imageList.addAll(thelist.sublist(0, 8));
    } else
      _imageList.addAll(thelist.sublist(0, thelist.length));

    return _imageList;
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostList(
        context: context, thelist: getprivates(theuser.privates!));
  }

  Widget _buildPostList(
      {required List<String>? thelist, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 510,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.5,
              crossAxisSpacing: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10),
              children: List.generate(thelist!.length, (index) {
                var isVideo = "${thelist[index]}".contains("fed");
                var thecorectUrl = isVideo
                    ? videoUrl(thelist[index], thumbnail: true, jaipaye: true)!
                    : imageUrl(thelist[index], jaipaye: true)!;

                if (8 == index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GridGalleryPublicTotal(
                                  showOverlays: showOverlays,
                                  theuser: theuser,
                                )),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      shadowColor: primaryColor,
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                Text(
                                  "View More",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: GestureDetector(
                      onTap: () {
                        if (showOverlays) {
                        } else {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return PostInformation(
                                    isVideo: isVideo, mediaId: thelist[index]);
                              });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              height: MediaQuery.of(context).size.height * .2,
                              fit: BoxFit.cover,
                              useOldImageOnUrlChange: false,
                              imageUrl: thecorectUrl,
                              placeholder: (context, url) => loadingImage(),
                              errorWidget: (context, url, error) =>
                                  errorImage(),
                            ).paddingAll(4).withWidth(double.infinity),
                            if (isVideo)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        onPressed: () async {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return PostInformation(
                                                    play: true,
                                                    isVideo: isVideo,
                                                    mediaId: thelist[index]);
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            if (showOverlays)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => SinglePayment(
                                              theuser,
                                              null,
                                              Rks.items,
                                            )),
                                  );
                                },
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: Center(
                                      child: ElasticIn(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.lock,
                                                size: 20, color: Colors.white),
                                          ],
                                        ).paddingAll(16),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
        ),
      ],
    );
  }
}
