import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/app_controller.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportUser extends StatefulWidget {
  final User currentUser;
  final User seconduser;

  ReportUser({required this.currentUser, required this.seconduser});

  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  TextEditingController reasonCtlr = TextEditingController();
  bool other = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Container(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.security,
                color: primaryColor,
                size: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Report User".tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Text(
              "False reports will result in your being banned. We do not condone lies or exaggerated reports!"
                  .tr()
                  .toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
      actions: !other
          ? <Widget>[
              Material(
                color: whiteColor,
                child: ListTile(
                    title: Text("Inappropriate Photos".tr().toString()),
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    onTap: () => _newReport(context, "Inappropriate Photos")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                color: whiteColor,
                child: ListTile(
                    title: Text(
                      "Feels Like Spam".tr().toString(),
                    ),
                    leading: Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.black,
                    ),
                    onTap: () => _newReport(context, "Feels Like Spam")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                color: whiteColor,
                child: ListTile(
                    title: Text(
                      "User is underage".tr().toString(),
                    ),
                    leading: Icon(
                      Icons.call_missed_outgoing,
                      color: Colors.black,
                    ),
                    onTap: () => _newReport(context, "User is underage")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                color: whiteColor,
                child: ListTile(
                    title: Text(
                      "Other".tr().toString(),
                    ),
                    leading: Icon(
                      Icons.report_problem,
                      color: blackColor,
                    ),
                    onTap: () {
                      setState(() {
                        other = true;
                      });
                    }),
              ),
            ]
          : <Widget>[
              Material(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: reasonCtlr,
                      decoration: InputDecoration(
                          hintText:
                              "Additional Info(optional)".tr().toString()),
                    ),
                    20.height,
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 5000),
                      child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 2,
                        heroTag: UniqueKey(),
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          _newReport(context, reasonCtlr.text)
                              .then((value) => Navigator.pop(context));
                        },
                        label: Text('Report User'),
                      ),
                    ),
                  ],
                ),
              ))
            ],
    );
  }

  Future _newReport(context, String reason) async {
    // await FirebaseFirestore.instance.collection("Reports").add({
    //   'reported_by': widget.currentUser.id,
    //   'victim_id': widget.seconduser.id,
    //   'reason': reason,
    //   'timestamp': FieldValue.serverTimestamp()
    // });
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
          return Center(
              child: Container(
                  width: 150.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "asset/auth/verified.jpg",
                        height: 60,
                        color: primaryColor,
                        colorBlendMode: BlendMode.color,
                      ),
                      Text(
                        "Reported".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 20),
                      )
                    ],
                  )));
        });
  }
}
