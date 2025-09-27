import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Welcome.dart';
import 'package:tharkyApp/Screens/auth/otp.dart';
import 'package:tharkyApp/Screens/auth/resset_pass.dart';
import 'package:tharkyApp/Screens/auth/sign_up_screen.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/components/loader_widget.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/constant.dart';
import 'package:tharkyApp/utils/images.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/string_extensions.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool? isOTPLogin;
  final String? verificationId;
  final String? otpCode;

  SignInScreen(
      {this.phoneNumber,
      this.isOTPLogin = false,
      this.otpCode,
      this.verificationId});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    passwordCont.text =
        widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void registerUser() async {
    Rks.context = context;
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        UserKeys.email: emailCont.text.trim(),
        UserKeys.userType: LOGIN_TYPE_USER,
        UserKeys.contactNumber: widget.phoneNumber ?? mobileCont.text.trim(),
        UserKeys.password: widget.phoneNumber ?? passwordCont.text.trim(),
        "repeatPassword": widget.phoneNumber ?? passwordCont.text.trim(),
      };

      await loginUser(request).then((res) async {
        saveUserData(res.data!, token: res.token);

        if (!res.data!.meta!["emailVerified"] &&
            !res.data!.meta!["phoneNumberVerified"]) {
          OTP(false, res.data!).launch(context);
        } else {
          Welcome().launch(context);
        }
      }).catchError((e) {
        my_inspect(e);
        // toast(e.toString());
      });
      appStore.setLoading(false);
    }
  }

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            16.width,
            BackWidget(
              iconColor: white,
            ),
          ],
        ),
        16.height,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to THARKY...".tr().toString(),
                style: boldTextStyle(
                  size: 18,
                  color: white,
                ),
              ),
              8.height,
              Text(
                "Hopefully you'll find a perfect style for you. Please sign in to your account as we care your privacy."
                    .tr()
                    .toString(),
                style: primaryTextStyle(size: 10, color: white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(24, 1, 24, 12),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
              blurRadius: 15, // Soft blur
              offset: Offset(0, 10), // Shadow offset (vertical offset of 10)
              spreadRadius: 5, // Spread radius for shadow
            ),
          ],
        ),
        child: Column(
          children: [
            22.height,
            Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Image.asset(
                  "asset/tharky.png",
                  fit: BoxFit.contain,
                ),
              ],
            ),
            22.height,
            AppTextField(
              textStyle: primaryTextStyle(color: Colors.white)
              // From nb_utils
              ,
              textFieldType: TextFieldType.EMAIL,
              controller: emailCont,
              cursorColor: redColor,
              focus: emailFocus,
              errorThisFieldRequired: "required",
              nextFocus: passwordFocus,
              decoration: inputDecoration2(context, labelText: "Email address"),
              suffix: ic_message
                  .iconImage(padding: 3, color: primaryColor)
                  .paddingAll(14),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.PASSWORD,
              textStyle: primaryTextStyle(color: Colors.white),
              // From nb_utils
              controller: passwordCont,
              focus: passwordFocus,
              readOnly:
                  widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
              suffixPasswordVisibleWidget:
                  ic_show.iconImage(padding: 10).paddingAll(14),
              suffixPasswordInvisibleWidget: ic_hide
                  .iconImage(padding: 3, color: primaryColor)
                  .paddingAll(14),
              errorThisFieldRequired: "required",
              decoration: inputDecoration2(context, labelText: "Password"),
              onFieldSubmitted: (s) {
                if (widget.isOTPLogin == false) registerUser();
              },
            ),
            20.height,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "I forgot my password !".tr().toString(),
                      style: TextStyle(color: whiteColor),
                    ),
                    onTap: () {
                      RessetPass({
                        "email": emailCont.text,
                      }).launch(context);
                    },
                  ),
                ],
              ),
            ),
            _buildTcAcceptWidget(),
            8.height,
            AppButton(
              text: "Signin".tr(),
              color: primaryColor,
              textStyle: boldTextStyle(color: white),
              width: context.width() - context.navigationBarHeight,
              onTap: () {
                if (widget.isOTPLogin == false) registerUser();
              },
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichTextWidget(
                  list: [
                    TextSpan(
                        text: "Don't have an account yet ? ",
                        style: secondaryTextStyle(size: 10, color: whiteColor)),
                    TextSpan(
                      text: " signup",
                      style: secondaryTextStyle(color: primaryColor, size: 10),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          SignUpScreen().launch(context);
                        },
                    ),
                  ],
                ).flexible(flex: 2),
              ],
            ),
          ],
        ));
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichTextWidget(
          list: [
            TextSpan(
                text: "We don't spam. we will take care of your ",
                style: secondaryTextStyle(size: 11, color: whiteColor)),
            TextSpan(
              text: " Privacy",
              style: secondaryTextStyle(color: primaryColor, size: 11),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(UPDATED_PRIVACY_POLICY_URL,
                      launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _orSignupSocial() {
    Widget _socialMediaButton({
      required Widget icon,
      required VoidCallback onPressed,
    }) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: icon,
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label: "Or sign up with"
          Text(
            "Or Sign up via",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialMediaButton(
                icon: ic_facebook.iconImage(padding: 6, color: primaryColor),
                onPressed: () {
                  print("Facebook Login");
                },
              ),
              4.width,
              _socialMediaButton(
                icon: ic_google.iconImage(padding: 6, color: primaryColor),
                onPressed: () {
                  print("Google Login");
                },
              ),
              4.width,
              _socialMediaButton(
                icon: ic_instagram.iconImage(padding: 6, color: primaryColor),
                onPressed: () {
                  print("Instagram Login");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    double circlesize = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.dark : Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stack(
          //   children: <Widget>[
          //     Positioned(
          //       top: -circlesize /
          //           1.4, //5Adjust this value to move it further up or down
          //       left: -circlesize / 4, // Adjust to position it horizontally
          //       child: Container(
          //         width: circlesize,
          //         height: circlesize,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle, // Circular shape
          //           gradient: LinearGradient(
          //             colors: [black, black],
          //             begin: Alignment
          //                 .topLeft, // Gradient starts from the top-left
          //             end: Alignment
          //                 .bottomRight, // Gradient ends at the bottom-right
          //           ),
          //         ),
          //         child: RandomLogoStack(
          //           circleSize: 50,
          //           numberOfLogos: 75, // Nombre de logos aléatoires
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          ListView(
            children: [
              _buildTopWidget(),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                // Disable auto validation
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(36, 1, 36, 1),
                  child: Column(
                    children: [
                      16.height,
                      _buildFormWidget(),
                      50.height,
                      // _orSignupSocial()
                    ],
                  ),
                ),
              ),
            ],
          ),
          Observer(
              builder: (_) =>
                  LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

class RandomLogoStack extends StatelessWidget {
  final double circleSize;
  final int numberOfLogos;

  RandomLogoStack({
    required this.circleSize,
    this.numberOfLogos = 10, // Par défaut, on génère 10 logos
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    List<Widget> logos = List.generate(numberOfLogos, (index) {
      // Générer des positions aléatoires
      double randomLeft = random.nextDouble() *
          (MediaQuery.of(context).size.width - circleSize);
      double randomTop = random.nextDouble() *
          (MediaQuery.of(context).size.height - circleSize);

      double randomRotation = random.nextDouble() * 2 * pi;

      return Positioned(
        top: randomTop * 1.5,
        left: randomLeft * 2,
        child: Transform.rotate(
          angle: randomRotation,
          child: Container(
            width: circleSize,
            height: circleSize,
            child: Image.asset(
              "asset/hookup4u-Logo-BW.png",
              fit: BoxFit.cover,
              width: circleSize,
              height: circleSize,
            ),
          ),
        ),
      );
    });

    return Stack(
      children: logos,
    );
  }
}
