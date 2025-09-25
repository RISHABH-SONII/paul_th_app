import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/auth/sign_in_screen.dart';
import 'package:tharkyApp/Screens/auth/sign_up_screen.dart';
import 'package:tharkyApp/components/mail_opener.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  //Replace your facebook id
  static const your_client_id = '562013580021680';

  static const your_redirect_url = 'https://00000000.firebaseapp.com/__/auth/handler';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: const Color.fromARGB(255, 0, 0, 0)),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  // ClipPath(
                  //   clipper: WaveClipper2(),
                  //   child: Container(
                  //     child: Column(),
                  //     width: double.infinity,
                  //     height: 280,
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(colors: [
                  //       darkPrimaryColor,
                  //       primaryColor.withOpacity(.15)
                  //     ])),
                  //   ),
                  // ),
                  // ClipPath(
                  //   clipper: WaveClipper3(),
                  //   child: Container(
                  //     child: Column(),
                  //     width: double.infinity,
                  //     height: 280,
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(colors: [
                  //       darkPrimaryColor,
                  //       primaryColor.withOpacity(.2)
                  //     ])),
                  //   ),
                  // ),
                  Container(
                    child: Image.asset(
                      "asset/tharky.png",
                      fit: BoxFit.contain,
                    ).paddingOnly(left: 50, right: 50, top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                ],
              ),
              Column(children: <Widget>[
                SizedBox(height: height/44),
                Container(
                  child: Text(
                    "By tapping 'Log in', you agree with our \n Terms.Learn how we process your data in \n our Privacy Policy and Cookies Policy."
                        .tr()
                        .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromARGB(137, 243, 243, 243), fontSize: 12),
                  ),
                ),
                16.height,
                // Material(
                //   elevation: 2.0,
                //   borderRadius: BorderRadius.all(Radius.circular(30)),
                //   color: primaryColor,
                //   child: Padding(
                //     padding: const EdgeInsets.all(2.0),
                //     child: InkWell(
                //       child: Container(
                //           decoration: BoxDecoration(
                //             shape: BoxShape.rectangle,
                //             borderRadius: BorderRadius.circular(25),
                //             color: Colors.black,
                //           ),
                //           height: MediaQuery.of(context).size.height * .065,
                //           width: MediaQuery.of(context).size.width * .8,
                //           child: Center(
                //               child: Text(
                //             "LOG IN WITH FACEBOOK".tr().toString(),
                //             style: TextStyle(
                //                 color: primaryColor,
                //                 fontWeight: FontWeight.bold),
                //           ))),
                //       onTap: () async {
                //         showDialog(
                //             context: context,
                //             builder: (context) => Container(
                //                 height: 30,
                //                 width: 30,
                //                 child: Center(
                //                     child: CupertinoActivityIndicator(
                //                   key: UniqueKey(),
                //                   radius: 20,
                //                   animating: true,
                //                 ))));

                //         await handleFacebookLogin(context).then((user) {
                //           navigationCheck(user, context);
                //         }).then((_) {
                //           Navigator.pop(context);
                //         }).catchError((e) {
                //           Navigator.pop(context);
                //         });
                //       },
                //     ),
                //   ),
                // ),
                12.height,
                OutlinedButton(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .68,
                    child: Center(
                        child: Text("LOG IN".tr().toString(),
                            style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.bold))),
                  ),
                  onPressed: () {
                    bool updateNumber = false;
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => SignInScreen()));
                  },
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account ? ".tr().toString(),
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign up".tr().toString(),
                        style: TextStyle(color: primaryColor),
                      ),
                      onTap: () => SignUpScreen().launch(context),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     GestureDetector(
              //       child: Text(
              //         "Privacy Policy".tr().toString(),
              //         style: TextStyle(color: primaryColor),
              //       ),
              //       onTap: () => _launchURL(
              //           "https://thenastycollectorsnastycollection.com/next-gen-dates-app/"),
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(left: 10, right: 10),
              //       height: 4,
              //       width: 4,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(100), color: Colors.blue),
              //     ),
              //     GestureDetector(
              //       child: Text(
              //         "Terms & Conditions".tr().toString(),
              //         style: TextStyle(color: primaryColor),
              //       ),
              //       onTap: () => _launchURL(
              //           "https://thenastycollectorsnastycollection.com/next-gen-dates-app/"),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Privacy Policy & Terms and Conditions".tr().toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _launchURL(
                        "https://thenastycollectorsnastycollection.com/next-gen-dates-policies/"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(
                      "English".tr().toString(),
                      style: TextStyle(color: white),
                    ),
                    onPressed: () {
                      EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Spanish".tr().toString(),
                      style: TextStyle(color: white),
                    ),
                    onPressed: () {
                      EasyLocalization.of(context)!.setLocale(Locale('es', 'ES'));
                    },
                  ),
                ],
              ),
              //Spacer(),
              Container(
                height: 150,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Image.asset(
                  'asset/applogo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: height/44,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    MailOpener.openGmailCompose(
                      email: "nextgendates@gmail.com",
                      subject: "Support Request",
                      body: "Hello, I need help with...",
                    );
                  },
                  child: Text(
                    "nextgendates@gmail.com",
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      onPopInvoked: (
          didPop,
          ) {
        if (didPop) {
          _onWillPop(context);
        }
      },
      // onPopInvokedWithResult: (didP, op) {
      //   _onWillPop(context);
      // },
    );
  }


  Future<User> handleFacebookLogin(context) async {
    late User user;

    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_friends',
        'user_gender',
        'user_link'
      ],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,friends,gender,link",
      );
      // you are logged
      final AccessToken accessToken = result.accessToken!;

      var request = {
        UserKeys.accessToken: result.accessToken!.token,
        UserKeys.firstName: userData["name"],
        UserKeys.email: userData["email"],
        UserKeys.dob: userData["birthday"],
        UserKeys.gender: userData["gender"],
        UserKeys.loginType: LOGIN_TYPE_FACEBOOK,
      };

      appStore.setLoading(true);
      await loginUser(request, isSocialLogin: true).then((res) async {
        await getUser(userId: "${res.data?.id}").then((res) async {
          if (res.id != null) {
            await saveUserData(res);
            try {
              user = res;
            } catch (e) {
              print('Error $e');
            }
          }
        });
      }).catchError((e) {
        toast(e.toString());
      });
      appStore.setLoading(false);
    } else {
      print(result.status);
      print(result.message);
    }

    return user;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(User currentUser, context) async {
    if (currentUser.address != null) {
      // Navigator.push(context,
      //     CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
    } else {
      // Navigator.push(
      //     context, CupertinoPageRoute(builder: (context) => Welcome()));
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'.tr().toString()),
          content: Text('Do you want to exit the app?'.tr().toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'.tr().toString()),
            ),
            TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text('Yes'.tr().toString()),
            ),
          ],
        );
      },
    );
    return true;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
