import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/UserInterests.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/snackbar.dart';

class SelectInterest extends StatefulWidget {
  final Map<String, dynamic> userData;
  SelectInterest(this.userData);

  @override
  _SelectInterestState createState() => _SelectInterestState();
}

class _SelectInterestState extends State<SelectInterest> {
  bool man = false;
  // bool woman = false;
  // bool eyeryone = false;

  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: BackWidgetuser(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "I'm interested in:".tr().toString(),
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 170),
          ),
          100.height,
          // Text(
          //   "You must click the requirements to become a member of Porn Star Wannabe... Any attempt to "
          //       "circumvent out very specific requirements will contravene out terms of service and result in immediate termination of your membership."
          //       .tr()
          //       .toString(),
          //   style: TextStyle(fontSize: 14),
          // ).paddingOnly(top: 200, left: 50, right: 50),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("MALE/MAN".tr().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: man ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  onPressed: () {
                    setState(() {
                      // woman = false;
                      man = !man;
                      // eyeryone = false;
                    });
                  },
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // OutlinedButton(
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * .065,
                //     width: MediaQuery.of(context).size.width * .75,
                //     child: Center(
                //         child: Text("WOMEN".tr().toString(),
                //             style: TextStyle(
                //                 fontSize: 20,
                //                 color: woman ? primaryColor : secondryColor,
                //                 fontWeight: FontWeight.bold))),
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       woman = !woman;
                //       man = false;
                //       eyeryone = false;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // OutlinedButton(
                //   //    focusColor: primaryColor,
                //   //    highlightedBorderColor: primaryColor,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * .065,
                //     width: MediaQuery.of(context).size.width * .75,
                //     child: Center(
                //         child: Text("EVERYONE".tr().toString(),
                //             style: TextStyle(
                //                 fontSize: 20,
                //                 color: eyeryone ? primaryColor : secondryColor,
                //                 fontWeight: FontWeight.bold))),
                //   ),
                //   // borderSide: BorderSide(
                //   //     width: 1,
                //   //     style: BorderStyle.solid,
                //   //     color: eyeryone ? primaryColor : secondryColor),
                //   // shape: RoundedRectangleBorder(
                //   //     borderRadius: BorderRadius.circular(25)),
                //   onPressed: () {
                //     setState(() {
                //       woman = false;
                //       man = false;
                //       eyeryone = !eyeryone;
                //     });
                //     // Navigator.push(
                //     //     context, CupertinoPageRoute(builder: (context) => OTP()));
                //   },
                // ),
              ],
            ),
          ).paddingTop(110),
          Padding(
            padding: const EdgeInsets.only(bottom: 120.0, left: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Checkbox(
                  activeColor: primaryColor,
                  value: select,
                  onChanged: (newValue) {
                    setState(() {
                      select = newValue!;
                    });
                  },
                ),
                title: Text("Show my interested gender on my feed".tr().toString()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                // onTap: (man || woman || eyeryone)
                onTap: (man)
                    ? () {
                  var userInterestGender;
                  // userInterestGender = {
                  //   'userInterestGender': man
                  //       ? "male"
                  //       : woman
                  //       ? "female"
                  //       : "everyone",
                  //   'showOnProfile': select
                  // };
                  userInterestGender = {
                    'userInterestGender': man
                        ? "male"
                        : "",
                    'showOnProfile': select
                  };

                  widget.userData.addAll(userInterestGender);
                  print("UserGender on sign up ::: $userInterestGender");
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => UserInterests(widget.userData)
                              // UserAbout(widget.userData)
                      ));
                  // ads.disable(ad1);
                }
                    : () {
                  CustomSnackbar.snackbar(
                      "Please select one".tr().toString(), context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // colors: (man || woman || eyeryone)
                      colors: (man)
                          ? [
                        primaryColor.withOpacity(.5),
                        primaryColor.withOpacity(.8),
                        primaryColor,
                        primaryColor,
                      ]
                          : [white, white],
                    ), // No gradient if username is empty
                    // color: (man || woman || eyeryone)
                    color: (man)
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
                        // color: (man || woman || eyeryone) ? white : secondryColor,
                        color: (man) ? white : secondryColor,
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
    );
  }
}
