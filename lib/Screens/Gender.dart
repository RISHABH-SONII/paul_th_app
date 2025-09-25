import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/UserAbout.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/snackbar.dart';

class Gender extends StatefulWidget {
  final Map<String, dynamic> userData;

  Gender(this.userData);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool male = false;
  bool cis = false;
  bool testes = false;
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
            child: Text(
              "ME".tr().toString(),
              style: TextStyle(fontSize: 40),
            ),
            padding: EdgeInsets.only(left: 50, top: 120),
          ),
          100.height,
          Text(
            "You must click the requirements to become a member of TH@RKY... Any attempt to circumvent out very specific requirements will contravene out terms of service and result in immediate termination of your membership."
                .tr()
                .toString(),
            style: TextStyle(fontSize: 14),
          ).paddingOnly(top: 200, left: 50, right: 50),

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
                        child: Text(/*"TRANS MALE"*/ "MALE/MAN".tr().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: male ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  onPressed: () {
                    setState(() {
                      male = !male;
                    });
                  },
                ),
                /*    10.height,
                OutlinedButton(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("TRANS WOMEN".tr().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: cis ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  onPressed: () {
                    setState(() {
                      cis = !cis;
                    });
                  },
                ),*/
                10.height,
                /*  OutlinedButton(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("TESTES".tr().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: testes ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  onPressed: () {
                    setState(() {
                      testes = !testes;
                    });
                  },
                ),*/
              ],
            ),
          ).paddingTop(110),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 100.0, left: 10),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: ListTile(
          //       leading: Checkbox(
          //         activeColor: primaryColor,
          //         value: select,
          //         onChanged: (newValue) {
          //           setState(() {
          //             select = newValue!;
          //           });
          //         },
          //       ),
          //       title: Text("Show my gender on my profile".tr().toString()),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: (male /*&& cis && testes*/)
                    ? () {
                        var userGender;
                        userGender = {
                          'userGender': male
                              ? "male"
                              : cis
                                  ? "cis"
                                  : "testes",
                          'showOnProfile': select
                        };

                        widget.userData.addAll(userGender);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    UserAbout(widget.userData)));
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
                      colors: (male /*&& cis && testes*/)
                          ? [
                              primaryColor.withOpacity(.5),
                              primaryColor.withOpacity(.8),
                              primaryColor,
                              primaryColor,
                            ]
                          : [white, white],
                    ), // No gradient if username is empty
                    color: (male /*&& cis && testes*/)
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
                            (male /*&& cis && testes*/) ? white : secondryColor,
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
