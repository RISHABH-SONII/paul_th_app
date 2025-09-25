import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/auth/otp.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class UpdateNumber extends StatelessWidget {
  final User currentUser;

  UpdateNumber(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Phone number settings".tr().toString(),
          style: TextStyle(color: blackColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Phone number".tr().toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Card(
                color: whiteColor.withOpacity(.8),
                child: ListTile(
                  title: Text(
                      currentUser.phoneNumber != null
                          ? "${currentUser.phoneNumber}"
                          : "Verify Phone number".tr().toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                  trailing: Icon(
                    currentUser.phoneNumber != null ? Icons.done : null,
                    color: primaryColor,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Verified phone number".tr().toString(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondryColor)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: InkWell(
                  child: Card(
                    color: whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("Update my phone number".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryColor)),
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => OTP(true, currentUser))),
                ),
              ),
            )
          ],
        ).paddingAll(12),
      ),
    );
  }
}
