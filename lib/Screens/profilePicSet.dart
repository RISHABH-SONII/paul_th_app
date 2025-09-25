import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/network/network_utils.dart';
import 'package:tharkyApp/utils/configs.dart';
import '../utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'AllowLocation.dart';
import 'package:http/http.dart';
import 'package:tharkyApp/utils/model_keys.dart';

class ProfilePicSet extends StatefulWidget {
  final userData;

  ProfilePicSet({Key? key, this.userData}) : super(key: key);

  @override
  State<ProfilePicSet> createState() => _ProfilePicSetState();
}

class _ProfilePicSetState extends State<ProfilePicSet> {
  String? imgUrl = '';
  bool isImageUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "Snap a pic! \nUpload your images to complete your profile",
                      style: TextStyle(fontSize: 20),
                    ),
                    padding: EdgeInsets.only(left: 40, top: 70),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.center,
                  child: Container(
                      width: 250,
                      height: 250,
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: !isImageUploaded
                          ? IconButton(
                              color: primaryColor,
                              iconSize: 60,
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () async {
                                await source(context, true);
                              },
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                imgUrl!,
                                width: 250,
                                height: 250,
                                fit: BoxFit.fill,
                              ))),
                ),
              ),
              isImageUploaded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
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
                                "CHANGE IMAGE",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () async {
                            await source(context, true);
                          },
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
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
                          'Continue',
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      print(widget.userData);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                AllowLocation(widget.userData),
                            // Gender(widget.userData)
                          ));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future source(BuildContext context, bool isProfilePicture) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add Picture'),
          content: Column(
            children: [
              Text('Select Source'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Camera Card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.camera, context, isProfilePicture);
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        color: white, // Background color
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 20,
                                color: primaryColor,
                              ),
                              1.height,
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gallery Card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.gallery, context, isProfilePicture);
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        color: white, // Background color
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 20,
                                color: primaryColor,
                              ),
                              1.height,
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          insetAnimationCurve: Curves.decelerate,
        );
      },
    );
  }

  Future getImage(ImageSource imageSource, context, isProfilePicture) async {
    ImagePicker imagePicker = ImagePicker();
    try {
      var image = await imagePicker.pickImage(source: imageSource);
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Crop',
            )
          ],
        );
        if (croppedFile != null) {
          await uploadFile(await compressimage(croppedFile), isProfilePicture);
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, isProfilePicture) async {
    // Check if image is valid
    if (!image.existsSync()) {
      toast("Image is not available", print: true);
      return;
    }

    MultipartRequest multiPartRequest =
        await getMultiPartRequest('upload/image');
    multiPartRequest.files
        .add(await MultipartFile.fromPath("image", image.path));
    multiPartRequest.fields["profile"] = "set";

    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          if ((data as String).isJson()) {
            data = json.decode(data) as Map<String, dynamic>?;

            var fileURL = "${BASE_URL}images/${data["image"]["shieldedID"]}";
            var imageId = "${data["image"]["_id"]}";

            setState(() {
              imgUrl = fileURL;
              isImageUploaded = true;
            });
            Rks.imageUrl = [imageId];
          }
        }
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future compressimage(CroppedFile image) async {
    final File croppedToFileImage = File(image.path);

    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image? imagefile = i.decodeImage(croppedToFileImage.readAsBytesSync());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));

    return compressedImagefile;
    // });
  }
}
