//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/UserInterests.dart';
import 'package:tharkyApp/Screens/selectInterest.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class UserAbout extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserAbout(this.userData);

  @override
  _UserAboutState createState() => _UserAboutState();
}

// late BannerAd ad1;
// Ads ads = new Ads();

class _UserAboutState extends State<UserAbout> {
  String about = '';

  @override
  void initState() {
    //  ad1 = ads.myBanner();
    super.initState();
    // ad1
    //   ..load()
    //   ..show(
    //     anchorOffset: 180.0,
    //     anchorType: AnchorType.bottom,
    //   );
  }

  @override
  void dispose() {
    // ads.disable(ad1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: BackWidgetuser(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "About me ".tr().toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    padding: EdgeInsets.only(left: 50, top: 120),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    // Allows multiline input
                    textInputAction: TextInputAction.newline,
                    // Add a new line with "Enter"
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "Spill the tea on your fashion inspo and the lifestyle that screams you. Bold, raw, and unapologetically real—let’s hear it."
                              .tr()
                              .toString(),
                      hintStyle:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      helperText:
                          "What’s your signature look? Share a little about your fashion and lifestyle choices!"
                              .tr()
                              .toString(),
                      helperStyle:
                          TextStyle(color: secondryColor, fontSize: 8.5),
                    ),
                    onChanged: (value) {
                      setState(() {
                        about = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: about.length > 0
                        ? () {
                            widget.userData.addAll({'about': "$about"});
                            print(widget.userData);

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SelectInterest(widget.userData),
                                      // UserInterests(widget.userData)),
                              ),
                            );
                          }
                        : null, // Disable the button if the username is empty
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: about.length > 0
                              ? [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor,
                                ]
                              : [white, white],
                        ), // No gradient if username is empty
                        color: about.length == 0
                            ? secondryColor
                            : primaryColor, // Fallback color for empty username
                      ),
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .75,
                      child: Center(
                        child: Text(
                          "CONTINUE".tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: about.length > 0 ? white : secondryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
