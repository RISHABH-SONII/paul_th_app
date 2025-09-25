import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/components/mapc/skeleton.dart';
import 'package:tharkyApp/components/videoplayer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/snackbar.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/utls.dart';

class PostDescriptor extends StatefulWidget {
  final String? id;
  final bool? isVideo;

  PostDescriptor({
    Key? key,
    this.id,
    this.isVideo,
  }) : super(key: key);

  @override
  State<PostDescriptor> createState() => _PostDescriptorState();
}

class _PostDescriptorState extends State<PostDescriptor> {
  final TextEditingController titlectrl = new TextEditingController();
  final TextEditingController descrctrl = new TextEditingController();
  bool isLoading = false;

  List<String> interests = [];

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      _getCurrentUser();
    }
  }

  _getCurrentUser() async {
    if (widget.id != 0) {
      setState(() {
        isLoading = true;
      });
      await gepost(id: "${widget.id}").then((res) async {
        Rks.postdescriptor!["title"] = titlectrl.text = "${res.title ?? ""}";
        Rks.postdescriptor!["id"] = "${res.id ?? ""}";
        Rks.postdescriptor!["description"] =
            descrctrl.text = "${res.description ?? ""}";
        Rks.postdescriptor!.addAll({'tags': interests = (res.tags ?? [])});
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future source(BuildContext context, {update_id}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text("Add pictures".tr().toString()),
              content: sourceSelect2(
                  context: context,
                  modifying: true,
                  callback: (croppedFile, {bool isVideoparam = false}) async {
                    setState(() {});
                  }),
              insetAnimationCurve: Curves.decelerate,
              actions: <Widget>[]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editing'),
        backgroundColor: whiteColor,
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLoading
                ? FractionallySizedBox(
                    widthFactor: .9,
                    alignment: Alignment.centerLeft,
                    child: Skeleton(
                      height: 150,
                    ),
                  ).paddingOnly(left: 22, bottom: 50, top: 8)
                : Stack(
                    children: [
                      Container(
                        child: Rks.postdescriptor!["f_conten"] != null
                            ? Rks.postdescriptor!["f_type"] == "image"
                                ? Image.file(
                                    Rks.postdescriptor!["f_conten"]!,
                                    fit: BoxFit.cover,
                                  ).withWidth(double.infinity).withHeight(500)
                                : SizedBox(
                                        height: 400,
                                        child: VideoPlayerWidget(
                                          videoFilePath: Rks
                                              .postdescriptor!["f_conten"]!
                                              .path,
                                        ).center()

                                        ///Commented by Shubham

                                        // .yellowed(color: gray.withOpacity(.2)),
                                        )
                                    .withWidth(double.infinity)
                            : widget.isVideo ?? false
                                ? SizedBox(
                                    height: 400,
                                    child: VideoPlayerWidget(
                                      videoUrl:
                                          videoUrl(Rks.postdescriptor!["id"])!,
                                    ),
                                  ).center()

                                ///Commented by Shubham
                                //.yellowed(color: gray.withOpacity(.2))
                                : CachedNetworkImage(
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    fit: BoxFit.cover,
                                    useOldImageOnUrlChange: true,
                                    imageUrl:
                                        imageUrl(Rks.postdescriptor!["id"])!,
                                    placeholder: (context, url) => Center(
                                      child: loadingImage(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        errorImage(),
                                  ).withWidth(double.infinity).withHeight(500),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          elevation: 2,
                          heroTag: UniqueKey(),
                          backgroundColor: blackColor,
                          onPressed: () async {
                            source(context);
                          },
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
            isLoading
                ? FractionallySizedBox(
                    widthFactor: .9,
                    alignment: Alignment.centerLeft,
                    child: Skeleton(
                      height: 50,
                    ),
                  ).paddingOnly(left: 22)
                : editUserField(
                    title: "Title",
                    textEditingController: titlectrl,
                    placeholder: "Enter a focus head",
                    onChanged: (value) {
                      Rks.postdescriptor!["title"] = value;
                    }),
            if (!isLoading) 10.height,
            isLoading
                ? FractionallySizedBox(
                    widthFactor: .9,
                    alignment: Alignment.centerLeft,
                    child: Skeleton(
                      height: 300,
                    ),
                  ).paddingOnly(left: 22, top: 20, bottom: 20)
                : editUserField(
                    title: "Description",
                    type: "textarea",
                    textEditingController: descrctrl,
                    placeholder:
                        "Serving looks and stealing hearts, one outfit at a time. What's your style story?"
                            .tr()
                            .toString(),
                    onChanged: (value) {
                      Rks.postdescriptor!["description"] = value;
                    }),
            if (!isLoading)
              editUserField(
                  title: "Tags",
                  type: "widget",
                  widget: SizedBox(
                    height: height/4.25,
                    child: InterestHorizontalListc(
                      interests: updateInterestList(interestList, interests),
                      onInterestToggle: (Map<String, dynamic> interest) {
                        setState(() {
                          interest['ontap'] = !interest['ontap'];
                          if (interest['ontap']) {
                            if (interests.length < MAXIMUM_INTERESTS) {
                              if (!interests.contains(interest['name'])) {
                                interests.add(interest['name']);
                              }
                            } else {
                              CustomSnackbar.snackbar(
                                  "select upto ${MAXIMUM_INTERESTS}"
                                      .tr()
                                      .toString(),
                                  context);
                            }
                          } else {
                            interests.remove(interest['name']);
                          }
                          Rks.postdescriptor!.addAll({'tags': interests});
                        });
                      },
                    ).paddingSymmetric(horizontal: 16),
                  ),
                  onChanged: (value) {
                    Rks.postdescriptor!["description"] = value;
                  }),
            Column(
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 5000),
                  child: Container(
                    width: 300,
                    child: FloatingActionButton(
                      elevation: 2,
                      heroTag: UniqueKey(),
                      backgroundColor: blackColor,
                      onPressed: () async {
                        Rks.postdescriptor!["go"] = "go";
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.id != null ? "Modify" : 'Post',
                        style: TextStyle(color: white),
                      ),
                    ).paddingSymmetric(horizontal: 50),
                  ),
                ),
                TextButton(
                  child: Text(
                    "cancel".tr().toString(),
                    style: TextStyle(color: blackColor),
                  ),
                  onPressed: () {
                    Rks.initdesciptor();
                    Navigator.pop(context);
                  },
                )
              ],
            ).withWidth(double.infinity)
          ],
        ).paddingAll(4),
      ),
    );
  }
}
