import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tharkyApp/Screens/components/postpage.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/network_utils.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostCreation extends StatefulWidget {
  final User currentUser;

  PostCreation(this.currentUser);

  @override
  PostCreationState createState() => PostCreationState();
}

class PostCreationState extends State<PostCreation>
    with SingleTickerProviderStateMixin {
  bool _isBlurred = true;
  late TabController _tabController;

  double _uploadProgress = 0.0; // Add this line
  bool _isUploading = false; // Add this line

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    Rks.onclickAddMedia = onclickAddMedia;
    Rks.source = source;
    Rks.uploadFile = uploadFile;
  }

  void _handleTabSelection() {
    setState(() {
      _isBlurred = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future source(BuildContext context,
      {delete_id, update_id, isprofile, onfinish}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text("Add pictures".tr().toString()),
              content: isprofile != null
                  ? sourceSelect(
                      context: context,
                      callback: (croppedFile) async {
                        await uploadFile(croppedFile,
                            delete_id: delete_id,
                            update_id: update_id,
                            onfinish: onfinish,
                            isprofile: isprofile);
                      })
                  : sourceSelect2(
                      context: context,
                      callback: (croppedFile,
                          {bool isVideoparam = false}) async {
                        if (Rks.postdescriptor!["go"] == "go") {
                          Rks.postdescriptor!["go"] = "no";
                          await uploadFile(croppedFile,
                              delete_id: delete_id,
                              update_id: update_id,
                              onfinish: onfinish,
                              isprofile: isprofile,
                              isVideoparam: isVideoparam);
                        }
                      }),
              insetAnimationCurve: Curves.decelerate,
              actions: <Widget>[]);
        });
  }

  Future uploadFile(File? image,
      {delete_id, update_id, onfinish, isprofile = null, isVideoparam}) async {
    appStore.setLoading(true);

    var user = {
      "delete_id": delete_id,
      "update_id": update_id,
      "title": Rks.postdescriptor!["title"],
      "description": Rks.postdescriptor!["description"],
      "tags": Rks.postdescriptor!["tags"],
      "${(isVideoparam ?? false) ? "video" : "image"}Id": update_id,
    };

    if (delete_id != null || image == null) {
    } else {
      String fileExtension = extension(image.path).toLowerCase();

      if (!image.existsSync()) {
        toast("Image is not available", print: true);
        appStore.setLoading(false);
        return;
      }

      // Determine if this is video or image based on parameter first, then fallback to extension
      bool isVideoFile = isVideoparam ?? isVideo(fileExtension);
      String path = isVideoFile ? "video" : "image";

      if (!isVideoFile && !isImage(fileExtension)) {
        toast("Unsupported file type: $fileExtension");
        appStore.setLoading(false);
        return;
      }

      if (Rks.postdescriptor!["f_conten"] != null) {
        MultipartRequest multiPartRequest =
            await getMultiPartRequest('upload/${path}');

        multiPartRequest.files
            .add(await MultipartFile.fromPath(path, image.path));

        // Add thumbnail if exists (for videos)
        if (Rks.postdescriptor!["thumbNail"] != null) {
          final thumbnailFile = File(Rks.postdescriptor!["thumbNail"]);

          // Print thumbnail details
          print('🗂️ THUMBNAIL DETAILS:');
          print('Path: ${thumbnailFile.path}');
          print('Exists: ${await thumbnailFile.exists()}');
          print('Size: ${(await thumbnailFile.length()) / 1024} KB');

          multiPartRequest.files.add(await MultipartFile.fromPath(
              "thumbNail", File(Rks.postdescriptor!["thumbNail"]).path));
        }

        if (isprofile != null) {
          multiPartRequest.fields["profile"] = "set";
        }
        try {
          if (_tabController.index == 1) {
            multiPartRequest.fields["isprivate"] = "set";
            user["private"] = _tabController.index == 1;
          }
        } catch (e) {}

        if (Rks.postdescriptor!['describe']) {
          multiPartRequest.fields["title"] = Rks.postdescriptor!["title"] ?? "";

          multiPartRequest.fields["tags"] =
              """${List<String>.from(Rks.postdescriptor!["tags"])}""";

          multiPartRequest.fields["description"] =
              Rks.postdescriptor!["description"] ?? "";
          Rks.postdescriptor!["describe"] = false;
        }

        multiPartRequest.headers.addAll(buildHeaderTokens());

        print('📦 UPLOAD REQUEST DETAILS:');
        print('URL: ${multiPartRequest.url}');
        print('Headers: ${multiPartRequest.headers}');
        print('Fields: ${multiPartRequest.fields}');
        print('Files:');
        multiPartRequest.files.forEach((file) {
          print('  ${file.field}: ${file.filename} (${file.length} bytes)');
        });

        await sendMultiPartRequest(
          multiPartRequest,
          onSuccess: (data) async {
            if (data != null) {
              if ((data as String).isJson()) {
                data = json.decode(data) as Map<String, dynamic>?;
                user["${path}Id"] = "${data[path]["_id"]}";
                print('Upload successful: ${user["${path}Id"]}');
                setState(() {
                  _uploadProgress = 0.0;
                  _isUploading = false;
                });
                appStore.setLoading(false);
              }
            }
          },
          onError: (error) {
            print('Upload error: $error');
            setState(() {
              _uploadProgress = 0.0;
              _isUploading = false;
            });
            toast(error.toString(), print: true);
          },
          onProgress: (int bytes, int totalBytes) {
            setState(() {
              _uploadProgress = bytes / totalBytes;
              _isUploading = true;
            });
          },
        ).catchError((e) {
          setState(() {
            _uploadProgress = 0.0;
            _isUploading = false;
          });
          print('Upload catch error: $e');
          toast(e.toString(), print: true);
        });
        Rks.initdesciptor();
      }
    }

    if (isprofile == null) {
      try {
        var value = await updateImages(user);

        var updatedList =
            (value.data as List).map((e) => e.toString()).toList();
        setState(() {
          if (_tabController.index == 1) {
            widget.currentUser.privates = updatedList;
          } else {
            widget.currentUser.images = updatedList;
          }
        });
        if (_tabController.index == 1) {
          appStore.setPrivates(updatedList);
        } else {
          appStore.setImages(updatedList);
        }
        return updatedList;
      } catch (e) {
        appStore.setLoading(false);
        myprint(e);
      }
    }
    appStore.setLoading(false);
    if (onfinish != null) {
      onfinish();
    }
    await Rks.update_current_user();

    setState(() {});
  }

  void onclickAddMedia(BuildContext context) async {
    myprint(_tabController.index);
    bool canUploadPhotos =
        _tabController.index == 1 || widget.currentUser.images!.length < 3;

    if (canUploadPhotos) {
      source(
        context,
      );
    } else {
      showInDialog(
        context,
        backgroundColor: whiteColor,
        contentPadding: EdgeInsets.zero,
        builder: (p0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "You can only add up to 3 contents in your public album !"
                          .tr()
                          .toString(),
                      style: TextStyle(
                          color: black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  AppButton(
                    child: Text("Cancel".tr(), style: secondaryTextStyle()),
                    elevation: 0,
                    onTap: () {
                      simulateScreenTap();
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text("ok".tr(),
                        style: boldTextStyle(color: primaryColor)),
                    elevation: 0,
                    onTap: () async {
                      simulateScreenTap();
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        title: Text(
          "My posts".tr().toString(),
          style: TextStyle(color: primaryColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 5000),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
              heroTag: UniqueKey(),
              backgroundColor: white,
              onPressed: () async {
                onclickAddMedia(context);
              },
              label: Text(
                'Add',
                style: TextStyle(color: primaryColor),
              ),
              icon: "asset/icons/ic_add.png"
                  .iconImage2(size: 30, color: primaryColor),
            ),
          ),
        ],
        backgroundColor: white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          tabs: [
            Tab(
              icon: "asset/icons/public.png"
                  .iconImage2(size: 30, color: primaryColor),
            ),
            Tab(
              icon: "asset/icons/private.png"
                  .iconImage2(size: 30, color: primaryColor),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              GridGallery(thelist: widget.currentUser.images!),
              Stack(
                children: [
                  GridGallery(thelist: widget.currentUser.privates!),
                  // Superposition floue (uniquement si _isBlurred est vrai)
                  if (_isBlurred)
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: ElasticIn(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "£1 per peek",
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.lock_open,
                                          size: 40, color: Colors.white),
                                      onPressed: () {
                                        // setState(() {
                                        //   _isBlurred = false;
                                        // });
                                      },
                                    ),
                                  ],
                                ).paddingAll(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          // Progress indicator overlay - moved outside TabBarView
          if (_isUploading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                          strokeWidth: 6,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Uploading... ${(_uploadProgress * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
