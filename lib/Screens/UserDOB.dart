import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tharkyApp/Screens/Gender.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';

class UserDOB extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserDOB(this.userData);

  @override
  _UserDOBState createState() => _UserDOBState();
}

class _UserDOBState extends State<UserDOB> {
  // String userDOB = '';
  late DateTime selecteddate;
  TextEditingController dobctlr = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: BackWidgetuser(),
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
                      "Date of birth".tr().toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    padding: EdgeInsets.only(left: 50, top: 120),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                      child: ListTile(
                    title: CupertinoTextField(
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      prefix: IconButton(
                        icon: (Icon(
                          Icons.calendar_today,
                          color: primaryColor,
                        )),
                        onPressed: () {},
                      ),
                      onTap: () => showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                child: GestureDetector(
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: DateTime(2000, 10, 12),
                                    onDateTimeChanged: (DateTime newdate) {
                                      setState(() {
                                        dobctlr.text = newdate.day.toString() +
                                            '/' +
                                            newdate.month.toString() +
                                            '/' +
                                            newdate.year.toString();
                                        selecteddate = newdate;
                                      });
                                    },
                                    maximumYear: 2002,
                                    minimumYear: 1800,
                                    maximumDate: DateTime(2002, 03, 12),
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                  onTap: () {
                                    print(dobctlr.text);
                                    Navigator.pop(context);
                                  },
                                ));
                          }),
                      placeholder: "DD/MM/YYYY",
                      controller: dobctlr,
                    ),
                    subtitle: Text(" Your age will be public".tr().toString()),
                  ))),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: dobctlr.text.length > 0
                        ? () {
                            widget.userData.addAll({
                              'user_DOB': "$selecteddate",
                              'age': ((DateTime.now()
                                          .difference(selecteddate)
                                          .inDays) /
                                      365.2425)
                                  .truncate(),
                            });
                            print(widget.userData);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        Gender(widget.userData)));
                          }
                        : null, // Disable the button if the username is empty
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: dobctlr.text.length > 0
                              ? [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor,
                                ]
                              : [white, white],
                        ), // No gradient if username is empty
                        color: dobctlr.text.length == 0
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
                                dobctlr.text.length > 0 ? white : secondryColor,
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
