import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tharkyApp/Screens/auth/sign_in_screen.dart';
import 'package:tharkyApp/components/copole.dart';
import 'package:tharkyApp/components/spin_kit_chasing_dots.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/snackbar.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';

class RessetPass extends StatefulWidget {
  final Map<String, dynamic> userData;

  RessetPass(this.userData);

  @override
  _RessetPassState createState() => _RessetPassState();
}

class _RessetPassState extends State<RessetPass> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cont = true;
  bool enterOtp = false;
  bool enterpass = false;
  String countryCode = '+1';
  TextEditingController phoneNumController = new TextEditingController();
  TextEditingController passcont = new TextEditingController();
  TextEditingController repasscont = new TextEditingController();
  String method = "email";
  String thething = "";
  String code = "";

  Timer? _timer;
  int _countdown = 120; // 2 minutes in seconds
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    phoneNumController.text = widget.userData["email"] ?? '';
    Rks.toastcolor = {"b": primaryColor, "c": whiteColor};
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer if initialized
    }

    cont = false;
    appStore.setLoading(false);
    Rks.toastcolor = {};
    super.dispose();
  }

  /// method to verify phone number and handle phone auth
  Future _verifyPhoneNumber(String phoneNumber) async {
    if (method == "phone") {
      phoneNumber = countryCode + phoneNumber.toString();
    } else {}
    thething = phoneNumber;
    var request = {
      "thething": phoneNumber,
      "method": method,
      "ressetpass": method,
      "id": widget.userData["id"]
    };
    if (phoneNumber.length < 4) {
      toast("email or phone number required");
      return;
    }

    setState(() {
      appStore.setLoading(true);
    });
    await verifyCredential(request).then((res) async {
      // if (res.data != null) {
      //   _verificationComplete(res.data!, context);
      // }
      if (res.data["result"] == "sent") {
        myprint(res.data["code"]);
        _smsCodeSent(res.data["code"]);
      } else {
        _verificationFailed("Verification failed", context);
      }
    }).catchError((e) {
      my_inspect(e);
    });
    setState(() {
      appStore.setLoading(false);
    });
  }

  /// method to verify phone number and handle phone auth
  Future chekEnteredCode(String code) async {
    setState(() {
      appStore.setLoading(true);
    });

    var request = {
      "thething": thething,
      "code": code,
      "method": method,
      "ressetpass": method,
      "id": widget.userData["id"]
    };

    await verifyCode(request).then((res) async {
      myprint(res.data);
      Rks.temptoken = res.data["token"];
      if (res.data["result"] == "ok") {
        setState(() {
          enterpass = true;
        });
      }
    }).catchError((e) {
      my_inspect(e);
    });
    setState(() {
      appStore.setLoading(false);
    });
  }

  /// method to verify phone number and handle phone auth
  Future changePass() async {
    var pass = passcont.text;
    var repass = repasscont.text;

    if (pass.length < 6 || repass.length < 6) {
      toast("Password too short, must be at least 6 characters.");
      return;
    }

    if (pass != repass) {
      toast("passwords don't match");
      return;
    }
    setState(() {
      appStore.setLoading(true);
    });
    var request = {
      "password": pass,
      "repeatPassword": repass,
      "token": Rks.temptoken
    };

    await changeUserPassword(request).then((res) async {
      if (res.data["result"] == "ok") {
        _verificationComplete(context);
        setState(() {
          enterOtp = false;
          enterpass = false;
        });
      }
    }).catchError((e) {
      my_inspect(e);
    });
    setState(() {
      appStore.setLoading(false);
    });
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
  _verificationComplete(BuildContext context) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          Future.delayed(Duration(seconds: 2), () async {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
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
                      16.height,
                      "asset/icons/ic_ok.png"
                          .iconImage2(size: 30, color: primaryColor),
                      Text(
                        "changed\n Successfully".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 15),
                      )
                    ],
                  )));
        });
  }

  _smsCodeSent(String verificationId) async {
    Future.delayed(Duration(seconds: 2), () {
      startCountdown();

      setState(() {
        enterOtp = true;
      });
    });
  }

  _verificationFailed(dynamic authException, BuildContext context) {
    CustomSnackbar.snackbar("Exception!! message:" + authException, context);
  }

  Widget build(BuildContext context) {
    Rks.context = context;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  "asset/tharky.png",
                  fit: BoxFit.contain,
                  height: 300,
                  width: MediaQuery.of(context).size.width / 1.12,
                ),
              ),
              BackButton(),
              ListTile(
                title: Text(
                  "Sorry to hear you lost your password.".tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Enter your email below".tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: enterpass
                      ? Column(
                          children: [
                            editUserField(
                                title: "New password",
                                type: "password",
                                textEditingController: passcont,
                                placeholder: "Enter your new password",
                                onChanged: (value) {
                                  setState(() {
                                    if (value.length > 3) {
                                      cont = true;
                                      passcont.text = value;
                                    } else {
                                      cont = false;
                                    }
                                  });
                                }),
                            editUserField(
                                title: "Confirm the new password",
                                type: "password",
                                textEditingController: repasscont,
                                placeholder: "re enter your new password",
                                onChanged: (value) {
                                  setState(() {
                                    if (value.length > 3) {
                                      cont = true;
                                      repasscont.text = value;
                                    } else {
                                      cont = false;
                                    }
                                  });
                                }),
                            20.height
                          ],
                        )
                      : enterOtp
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      text: "Enter the code sent to "
                                          .tr()
                                          .toString(),
                                      children: [
                                        TextSpan(
                                            text: thething,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                fontSize: 15)),
                                      ],
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15)),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: PinCodeTextField(
                                    keyboardType: TextInputType.number,
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.underline,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 35,
                                    ),
                                    //shape: PinCodeFieldShape.underline,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    //fieldHeight: 50,
                                    //fieldWidth: 35,
                                    onChanged: (value) {
                                      code = value;
                                    },
                                    appContext: context,
                                  ),
                                ),
                                20.height,
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: "Didn't receive the code? "
                                          .tr()
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15),
                                      children: [
                                        TextSpan(
                                          text: _isButtonEnabled
                                              ? " RESEND".tr().toString()
                                              : " RESEND in ${formatTimedecount(_countdown)}",
                                          style: TextStyle(
                                            color: _isButtonEnabled
                                                ? Color(0xFF91D3B3)
                                                : Colors.grey,
                                            fontSize: 16,
                                          ),
                                          recognizer: _isButtonEnabled
                                              ? (TapGestureRecognizer()
                                                ..onTap = () {
                                                  continueVerify();
                                                  startCountdown();
                                                })
                                              : null,
                                        ),
                                        TextSpan(
                                          text: "\n or ",
                                        ),
                                        TextSpan(
                                          text:
                                              "change the ${method == "email" ? "email" : "phone number"}",
                                          style: TextStyle(
                                              color: darkOrchid,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _timer!.cancel();
                                              setState(() {
                                                _isButtonEnabled = true;
                                                enterOtp = false;
                                              });
                                            },
                                        ),
                                      ]),
                                ),
                                20.height,
                                appStore.isLoading
                                    ? SpinKitChasingDots(
                                        color: primaryColor,
                                      )
                                    : code.length < 5
                                        ? Text("")
                                        : InkWell(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          primaryColor
                                                              .withOpacity(.5),
                                                          primaryColor
                                                              .withOpacity(.8),
                                                          primaryColor,
                                                          primaryColor
                                                        ])),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .065,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .75,
                                                child: Center(
                                                    child: Text(
                                                  "VERIFY".tr().toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))),
                                            onTap: () async {
                                              chekEnteredCode(code);
                                            },
                                          )
                              ],
                            )
                          : method == "email"
                              ? editUserField(
                                  title: "Email",
                                  type: TextInputType.emailAddress,
                                  textEditingController: phoneNumController,
                                  placeholder: "Enter your email address",
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length > 3) {
                                        cont = true;
                                        phoneNumController.text = value;
                                      } else {
                                        cont = false;
                                      }
                                    });
                                  })
                              : editUserField(
                                  title: "Phone Number",
                                  textEditingController: phoneNumController,
                                  placeholder: "Enter your phone number",
                                  type: "phone",
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length > 6) {
                                        cont = true;
                                        phoneNumController.text = value;
                                      } else {
                                        cont = false;
                                      }
                                    });
                                  },
                                )),
              if (!enterOtp)
                TextButton(
                  child: Text(
                    "use my ${method == "email" ? "phone" : "email"}"
                        .tr()
                        .toString(),
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () {
                    phoneNumController.text = "";
                    cont = false;
                    setState(() {
                      method = method == "email" ? "phone" : "email";
                    });
                  },
                ),
              if (!enterOtp || enterpass)
                appStore.isLoading
                    ? SpinKitChasingDots(
                        color: primaryColor,
                      )
                    : InkWell(
                        child: Container(
                            decoration: cont
                                ? BoxDecoration(
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
                                        ]))
                                : BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                            height: MediaQuery.of(context).size.height * .065,
                            width: MediaQuery.of(context).size.width * .75,
                            child: Center(
                                child: Text(
                              "CONTINUE".tr().toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                        onTap: () async {
                          if (enterpass) {
                            changePass();
                          } else {
                            continueVerify();
                          }
                        },
                      )
            ],
          ),
        ),
      ),
    );
  }

  void startCountdown() {
    setState(() {
      _isButtonEnabled = false;
      _countdown = 120; // Reset the countdown to 2 minutes
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
        _timer!.cancel();
      }
    });
  }

  void continueVerify() async {
    if (!cont) return;
    showDialog(
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        return Center(
            child: CupertinoActivityIndicator(
          radius: 20,
        ));
      },
      barrierDismissible: false,
      context: context,
    );
    await _verifyPhoneNumber(phoneNumController.text);
  }
}
