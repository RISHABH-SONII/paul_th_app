import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tharkyApp/Screens/profilePicSet.dart';
// import 'package:tharkyApp/Screens/ShowGender.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class UserInterests extends StatefulWidget {
  final Map<String, dynamic> userData;
  UserInterests(this.userData);

  @override
  _UserInterestsState createState() => _UserInterestsState();
}

class _UserInterestsState extends State<UserInterests> {
  List selected = [];
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: BackWidgetuser(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(
                  "I'm into".tr().toString(),
                  style: TextStyle(fontSize: 40, color: black),
                ),
                padding: EdgeInsets.only(left: 50, top: 120),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: interestList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: black,
                        ),
                        child: Container(
                          color: black,
                          height: MediaQuery.of(context).size.height * .055,
                          width: MediaQuery.of(context).size.width * .65,
                          child: Center(
                              child: Row(
                            children: [
                              Text("${interestList[index]["emoji"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: interestList[index]["ontap"]
                                          ? primaryColor
                                          : white,
                                      fontWeight: FontWeight.bold)),
                              5.width,
                              Text("${interestList[index]["name"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: interestList[index]["ontap"]
                                          ? primaryColor
                                          : white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            if (selected.length < MAXIMUM_INTERESTS) {
                              interestList[index]["ontap"] =
                                  !interestList[index]["ontap"];
                              if (interestList[index]["ontap"]) {
                                selected.add(interestList[index]["name"]);
                                print(interestList[index]["name"]);
                              } else {
                                selected.remove(interestList[index]["name"]);
                              }
                            } else {
                              if (interestList[index]["ontap"]) {
                                interestList[index]["ontap"] =
                                    !interestList[index]["ontap"];
                                selected.remove(interestList[index]["name"]);
                              } else {
                                CustomSnackbar.snackbar(
                                    "select upto ${MAXIMUM_INTERESTS}"
                                        .tr()
                                        .toString(),
                                    context);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: select,
                      onChanged: (newValue) {
                        setState(() {
                          select = newValue!;
                        });
                      },
                    ),
                    title:
                        Text("Show my interests on my profile".tr().toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: selected.length > 0
                            ? () {
                                widget.userData.addAll({
                                  "interests": {
                                    'tags': selected,
                                    'showOnProfile': select
                                  },
                                });
                                print(widget.userData);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ProfilePicSet(
                                            userData: widget.userData)
                                        //AllowLocation(widget.userData),
                                        ));
                              }
                            : () {
                                CustomSnackbar.snackbar(
                                    "Please select one".tr().toString(),
                                    context);
                              }, // Disable the button if the username is empty
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: selected.length > 0
                                  ? [
                                      primaryColor.withOpacity(.5),
                                      primaryColor.withOpacity(.8),
                                      primaryColor,
                                      primaryColor,
                                    ]
                                  : [white, white],
                            ), // No gradient if username is empty
                            color: selected.length == 0
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
                                color:
                                    selected.length > 0 ? white : secondryColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
