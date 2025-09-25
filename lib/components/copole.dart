import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as i;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart'; // You can remove this if it's not used in the updated widget
import 'package:path_provider/path_provider.dart';
import 'package:tharkyApp/Screens/Profile/PostDescriptor.dart';
import 'package:tharkyApp/components/common_ui.dart';
import 'package:tharkyApp/components/confirmation_dialog.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/components/mapc/map_view.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

///Commented by Imran
//import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';

Widget editUserField(
    {required title,
    textEditingController,
    placeholder,
    onChanged,
    widget,
    onmapTap,
    type = TextInputType.name,
    dynamic onTap}) {
  var titleW = Text(
    easy.tr("${title}").toString(),
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: blackColor),
  ).paddingSymmetric(vertical: 5);
  switch (type) {
    case "place":
      return ListTile(
        titleAlignment: ListTileTitleAlignment.bottom,
        title: titleW,
        subtitle: CupertinoTextField(
          controller: textEditingController,
          cursorColor: primaryColor,
          placeholder: easy.tr("${placeholder}").toString(),
          padding: EdgeInsets.all(10),
          onChanged: onChanged ?? (text) {},
          onTap: onTap,
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Background color
            border: Border.all(
              color: transparentColor, // Border color
              width: 2.0, // Border width
            ),
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        trailing: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 5000),
            child: Container(
              height: 50,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                heroTag: UniqueKey(),
                backgroundColor: Colors.white,
                onPressed: () async {
                  // Register your HomeController before running the app
                  Get.put(HomeController());
                  final result = await Get.to(() => MapViewHome({"editing": 1}));
                  if (result != null) {
                    onmapTap(result);
                  }
                },
                label: "asset/icons/choose_location.png".iconImage2(size: 30, color: black),
              ),
            )),
      );

    case "textarea":
      return ListTile(
          title: titleW,
          subtitle: CupertinoTextField(
            controller: textEditingController,
            cursorColor: primaryColor,
            placeholder: easy.tr("${placeholder}").toString(),
            maxLines: 10,
            minLines: 4,
            padding: EdgeInsets.all(10),
            onChanged: onChanged ?? (text) {},
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Background color
              border: Border.all(
                color: transparentColor, // Border color
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ));

    case "date":
      return ListTile(
          title: titleW,
          subtitle: CupertinoTextField(
            readOnly: true,
            keyboardType: TextInputType.phone,
            prefix: IconButton(
              icon: (Icon(
                Icons.calendar_month,
              )),
              onPressed: onChanged,
            ),
            onTap: onChanged,
            placeholder: placeholder,
            controller: textEditingController,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                color: transparentColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ));

    case "verify":
      return ListTile(
          title: titleW,
          subtitle: CupertinoTextField(
            readOnly: true,
            keyboardType: TextInputType.phone,
            suffix: IconButton(
              icon: (Icon(
                Icons.arrow_forward_ios,
              )),
              onPressed: onChanged,
            ),
            onTap: onChanged,
            placeholder: placeholder,
            controller: textEditingController,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(
                color: transparentColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ));
    case "phone":
      String countryCode = "+44"; // Default country code

      return ListTile(
        title: titleW,
        subtitle: Row(
          children: [
            // CountryCodePicker for selecting country codes
            CountryCodePicker(
              flagWidth: 20,
              padding: EdgeInsets.all(0),
              searchPadding: EdgeInsets.all(0),
              margin: EdgeInsets.only(right: 10), // Spacing
              onChanged: (value) {
                countryCode = value.dialCode!;
              },
              initialSelection: 'GB',
              favorite: [countryCode, 'GB'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
            // CupertinoTextField for phone input
            Expanded(
              child: CupertinoTextField(
                controller: textEditingController,
                cursorColor: primaryColor,
                placeholder: easy.tr("${placeholder}").toString(),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                keyboardType: TextInputType.phone,
                onChanged: onChanged ?? (text) {},
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Background color
                  border: Border.all(
                    color: transparentColor, // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      );
    case "password":
      bool isPasswordVisible = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            title: titleW,
            subtitle: CupertinoTextField(
              controller: textEditingController,
              cursorColor: primaryColor,
              placeholder: easy.tr("${placeholder}").toString(),
              padding: EdgeInsets.all(10),
              obscureText: !isPasswordVisible, // Toggle visibility
              onChanged: onChanged ?? (text) {},
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // Background color
                border: Border.all(
                  color: transparentColor, // Border color
                  width: 2.0, // Border width
                ),
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: primaryColor,
                ).paddingOnly(right: 10),
              ),
            ),
          );
        },
      );
    case "widget":
      return StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            title: titleW,
            subtitle: widget,
          );
        },
      );
    default:
      return ListTile(
          title: titleW,
          subtitle: CupertinoTextField(
            controller: textEditingController,
            cursorColor: primaryColor,
            placeholder: easy.tr("${placeholder}").toString(),
            padding: EdgeInsets.all(10),
            keyboardType: type,
            onChanged: onChanged ?? (text) {},
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Background color
              border: Border.all(
                color: transparentColor, // Border color
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ));
  }
}

Widget sourceSelect({required BuildContext context, isProfilePicture = false, callback}) {
  return Column(
    children: [
      Text('Select Source'),
      Text(
          'It is strictly prohibited for minors to use ROAR. The official team will monitor live content 24/7 to prevent the spread of illegal, vulgar, pornographic, gambling, fraudulent, superstitious, violent, gory content, as well as scam solicitations and prohibited items. Please exercise caution and sound judgment in your consumption, and do not engage in private transactions or transfers with others. If you notice any violations, please report the content promptly.'),
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
                    getImage(ImageSource.camera, context, isProfilePicture,
                        callback: callback);
                    return Center(
                        child: LinearProgressIndicator(
                      color: whiteColor,
                    ).paddingSymmetric(horizontal: 16));
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    getImage(ImageSource.gallery, context, isProfilePicture,
                        callback: callback);
                    return Center(
                        child: LinearProgressIndicator(
                      color: whiteColor,
                    )).paddingSymmetric(horizontal: 16);
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
  );
}

Widget sourceSelect2(
    {required BuildContext context, isProfilePicture = false, required Function(File, {bool isVideoparam}) callback, modifying}) {
  if (!(modifying != null && modifying)) {
    Rks.postdescriptor!["describe"] = true;
  }

  return Column(
    children: [
      Text('Select Source'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Camera Card
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  getImage(ImageSource.camera, context, isProfilePicture,
                      callback: (file) => callback(file));
                  return Center(
                    child: LinearProgressIndicator(
                      color: whiteColor,
                    ).paddingSymmetric(horizontal: 16),
                  );
                },
              );
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: white, // Background color
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
                        fontSize: 8, color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ).paddingAll(10),
            ),
          ).paddingAll(8),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  getImage(ImageSource.gallery, context, isProfilePicture,
                      callback: (file) => callback(file));
                  return Center(
                      child: LinearProgressIndicator(
                    color: whiteColor,
                  )).paddingSymmetric(horizontal: 16);
                },
              );
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: white, // Background color
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
                        fontSize: 8, color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ).paddingAll(10),
            ),
          ).paddingAll(8),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  getMedia(ImageSource.gallery, context, isProfilePicture,
                    callback: (File videoFile, {bool isVideoparam = false}) {
                      // This is where you handle the selected video file
                      callback(videoFile, isVideoparam: true); // Pass through to parent callback
                    },);
                  return Center(
                      child: LinearProgressIndicator(
                    color: primaryColor,
                  ));
                },
              );
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: white, // Background color
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.video_collection_sharp,
                    size: 20,
                    color: primaryColor,
                  ),
                  1.height,
                  Text(
                    'Video',
                    style: TextStyle(
                        fontSize: 8, color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ).paddingAll(10),
            ),
          ).paddingAll(8),
        ],
      ),
      Text('It is strictly prohibited for minors to use ROAR. The official team will monitor live content 24/7 to prevent the spread of illegal, vulgar, pornographic, gambling, fraudulent, superstitious, violent, gory content, as well as scam solicitations and prohibited items. Please exercise caution and sound judgment in your consumption, and do not engage in private transactions or transfers with others. If you notice any violations, please report the content promptly.')
          .paddingAll(12),
    ],
  );
}

Future getImage(ImageSource imageSource, context, isProfilePicture,
    {Function(File)? callback, cropcircle = false}) async {
  ImagePicker imagePicker = ImagePicker();
  try {
    var image = await imagePicker.pickImage(source: imageSource);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: cropcircle ? CropStyle.circle : CropStyle.rectangle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Crop',
          )
        ],
      );

      if (croppedFile != null) {
        Rks.postdescriptor!["f_type"] = "image";
        Rks.postdescriptor!["f_conten"] = File(croppedFile.path);
        await describeit(context);

        callback?.call(Rks.postdescriptor!["f_conten"]);
        // callback(Rks.postdescriptor!["f_conten"]);
      }
    }
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
  }
}

Future getMedia(ImageSource imageSource, context, isProfilePicture,
    {required Function(File, {bool isVideoparam}) callback, cropcircle = false}) async {
  ImagePicker imagePicker = ImagePicker();
  FlutterVideoInfo _flutterVideoInfo = FlutterVideoInfo();

  try {
    var image = await imagePicker.pickVideo(source: imageSource);

    if (image != null && image.path.isNotEmpty) {
      final File croppedToFileImage = File(image.path);

      double fileSize = await getFileSizeInMB(croppedToFileImage);

      VideoData? videoInfo =
          await _flutterVideoInfo.getVideoInfo(croppedToFileImage.path);

      if (fileSize > maxUploadMB) {
        Get.dialog(ConfirmationDialog(
          aspectRatio: 1.8,
          title1: "Too Large video",
          title2: "This video is greater than 50 mb Please select another...",
          positiveText: "Select another",
          onPositiveTap: () {
            Get.back();
          },
        ));

        return;
      }

      if (((videoInfo?.duration ?? 0) / 1000) > maxUploadSecond) {
        Get.dialog(ConfirmationDialog(
          aspectRatio: 1.8,
          title1: "Too Long video",
          title2: "This video is greater than 10 min Please select another...",
          positiveText: "Select another",
          onPositiveTap: () {
            Get.back();
          },
        ));
        return;
      }

      // Generate thumbnail
      final String? thumbnailPath =
      await generateVideoThumbnail(croppedToFileImage.path);

      if (thumbnailPath != null) {
        Rks.postdescriptor!["thumbNail"] = thumbnailPath;
        Rks.postdescriptor!["f_type"] = "video";
        Rks.postdescriptor!["f_conten"] = croppedToFileImage;
        await describeit(context);
        callback.call(croppedToFileImage, isVideoparam: true);
      }
    }
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
    print('Error picking video: $e');
  }
}

Future<String?> generateVideoThumbnail(String videoPath) async {
  try {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
      timeMs: 1000, // Get frame at 1 second
    );

    if (uint8list != null) {
      final directory = await getTemporaryDirectory();
      final thumbnailFile = File(
          '${directory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await thumbnailFile.writeAsBytes(uint8list);
      return thumbnailFile.path;
    }
  } catch (e) {
    print('Error generating thumbnail: $e');
  }
  return null;
}

Future describeit(context) async {
  if (Rks.postdescriptor!["describe"]) {
    await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => PostDescriptor()));
  }
}

Future compressimage(CroppedFile image) async {
  final File croppedToFileImage = File(image.path);
  final tempdir = await getTemporaryDirectory();
  final path = tempdir.path;
  i.Image? imagefile = i.decodeImage(croppedToFileImage.readAsBytesSync());
  final compressedImagefile = File('$path.jpg')
    ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));
  return compressedImagefile;
}

class InterestHorizontalListc extends StatefulWidget {
  final List<Map<String, dynamic>> interests;
  final Function(Map<String, dynamic>) onInterestToggle;

  const InterestHorizontalListc({
    Key? key,
    required this.interests,
    required this.onInterestToggle,
  }) : super(key: key);

  @override
  _InterestHorizontalListState createState() => _InterestHorizontalListState();
}

class _InterestHorizontalListState extends State<InterestHorizontalListc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (widget.interests.length / 2).ceil(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            InterestCard(
              interest: widget.interests[index * 2],
              onTap: () => widget.onInterestToggle(widget.interests[index * 2]),
            ),
            if (index * 2 + 1 < widget.interests.length)
              InterestCard(
                interest: widget.interests[index * 2 + 1],
                onTap: () => widget.onInterestToggle(widget.interests[index * 2 + 1]),
              ),
          ],
        );
      },
    );
  }
}

class InterestCard extends StatelessWidget {
  final Map<String, dynamic> interest;
  final VoidCallback onTap;

  const InterestCard({
    Key? key,
    required this.interest,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width/6,
        height: MediaQuery.of(context).size.height/10,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: interest['ontap'] == true ? interest['color'].withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: interest['ontap'] == true
              ? [
                  BoxShadow(
                    color: interest['color'].withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              interest['emoji'],
              style: TextStyle(fontSize: 30),
            ),
            Text(
              interest['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterestHorizontalListc2 extends StatelessWidget {
  final List<Map<String, dynamic>> interests;

  const InterestHorizontalListc2({
    Key? key,
    required this.interests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (interests.length / 2).ceil(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            InterestCard2(
              interest: interests[index * 2],
            ),
            if (index * 2 + 1 < interests.length)
              InterestCard2(
                interest: interests[index * 2 + 1],
              ),
          ],
        );
      },
    );
  }
}

class InterestCard2 extends StatelessWidget {
  final Map<String, dynamic> interest;

  const InterestCard2({
    Key? key,
    required this.interest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 80,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              interest['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AsymmetricTagList extends StatelessWidget {
  final List<String> tags;

  const AsymmetricTagList({Key? key, required this.tags}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            children: tags.map((tag) {
              return _buildTagCard(tag);
            }).toList(),
          ),
        ],
      ),
    ).withWidth(double.infinity);
  }

  // Widget to build individual tags with dynamic width
  Widget _buildTagCard(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

Future<double> getFileSizeInMB(File file) async {
  try {
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  } catch (e) {
    print('Error getting file size: $e');
    return -1;
  }
}
//

// Future getMedia2(ImageSource imageSource, context, isProfilePicture,
//     {callback, cropcircle = false}) async {
//   ImagePicker imagePicker = ImagePicker();
//
//   try {
//     var images = await imagePicker.pickMultipleMedia();
//
//     for (XFile image in images) {
//       if (image.path.isNotEmpty) {
//         final File croppedToFileImage = File(image.path);
//
//         ///Commented by Imran
//         // try {
//         //   String localPath = await findLocalPath();
//         //   await FFmpegKit.execute(
//         //       '-i "${croppedToFileImage.path}" -y $localPath${Platform.pathSeparator}sound.wav');
//         //   await FFmpegKit.execute(
//         //       '-i "${croppedToFileImage.path}" -y -ss 00:00:1.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
//         //
//         //   Rks.postdescriptor!["thumbNail"] =
//         //       "$localPath${Platform.pathSeparator}thumbNail.png";
//         // } catch (e) {
//         //   Get.back(); // Close the loader if FF mpeg fails
//         //   CommonUI.showToast(
//         //       msg:
//         //           "An error occurred while processing the video. Please try again.");
//         // }
//         Rks.postdescriptor!["f_type"] = "video";
//         Rks.postdescriptor!["f_conten"] = croppedToFileImage;
//         Rks.postdescriptor!["go"] = "go";
//
//         // await describeit(context);
//
//         await callback(croppedToFileImage);
//       }
//     }
//
//     Navigator.pop(context);
//   } catch (e) {
//     Navigator.pop(context);
//   }
// }
//
// Future getImage2(ImageSource imageSource, context, isProfilePicture, {callback}) async {
//   final ImagePicker imagePicker = ImagePicker();
//   try {
//     final List<XFile> pickedFiles = await imagePicker.pickMultiImage();
//
//     if (pickedFiles.isNotEmpty) {
//       for (XFile xFile in pickedFiles) {
//         File file = File(xFile.path);
//
//         Rks.postdescriptor!["f_type"] = "image";
//         Rks.postdescriptor!["f_conten"] = file;
//         Rks.postdescriptor!["go"] = "go";
//         // await describeit(context);
//
//         callback(Rks.postdescriptor!["f_conten"]);
//
//         await callback(file);
//       }
//     }
//     Navigator.pop(context);
//   } catch (e) {
//     print('Error processing multiple images: $e');
//     Navigator.pop(context);
//   }
// }

Future getImageMessage(ImageSource source, BuildContext context, bool isProfilePicture,
    {required Function(File file, String type) callback, cropcircle = false}) async {
  final picker = ImagePicker();
  try {
    if (source == ImageSource.gallery) {
      final picked = await showModalBottomSheet<XFile?>(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Pick Image'),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(_, file);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Pick Video'),
                onTap: () async {
                  final file = await picker.pickVideo(source: ImageSource.gallery);
                  Navigator.pop(_, file);
                },
              ),
            ],
          ),
        ),
      );

      if (picked != null) {
        if (picked.path.endsWith(".mp4") || picked.path.endsWith(".mov")) {
          callback(File(picked.path), 'video');
        } else {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: picked.path,
            cropStyle: cropcircle ? CropStyle.circle : CropStyle.rectangle,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: black,
                toolbarWidgetColor: Colors.white,
              ),
              IOSUiSettings(
                minimumAspectRatio: 1.0,
                title: 'Crop',
              )
            ],
          );

          if (croppedFile != null) {
            callback(File(croppedFile.path), 'image');
          }
        }
      }
    }
    else {
      // For camera
      final image = await picker.pickImage(source: source);
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          cropStyle: cropcircle ? CropStyle.circle : CropStyle.rectangle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: black,
              toolbarWidgetColor: Colors.white,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Crop',
            )
          ],
        );

        if (croppedFile != null) {
          callback(File(croppedFile.path), 'image');
        }
      }
    }
  } catch (e) {
    print("Media pick error: $e");
    Navigator.pop(context);
  }
}
