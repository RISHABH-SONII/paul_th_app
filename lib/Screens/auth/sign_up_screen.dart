import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/auth/otp.dart';
import 'package:tharkyApp/Screens/auth/resset_pass.dart';
import 'package:tharkyApp/Screens/auth/sign_in_screen.dart';
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

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool? isOTPLogin;
  final String? verificationId;
  final String? otpCode;

  SignUpScreen(
      {this.phoneNumber,
      this.isOTPLogin = false,
      this.otpCode,
      this.verificationId});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController phoneNumController = new TextEditingController();

  bool cont = false;
  String countryCode = '+44';

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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
        UserKeys.firstName: fNameCont.text.trim(),
        UserKeys.lastName: lNameCont.text.trim(),
        UserKeys.email: emailCont.text.trim(),
        UserKeys.userType: LOGIN_TYPE_USER,
        UserKeys.contactNumber: "${countryCode + phoneNumController.text}",
        UserKeys.password: widget.phoneNumber ?? passwordCont.text.trim(),
        "repeatPassword": widget.phoneNumber ?? passwordCont.text.trim(),
      };
      print(request);
      await createUser(request).then((value) async {
        print("create........");
        var res = await loginUser(request);
        await saveUserData(res.data!, token: res.token);

        OTP(false, res.data!).launch(context);
      }).catchError((e) {
        print("Register.....errror $e");
        print(e);
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
        15.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            16.width,
            BackWidget(
              iconColor: white,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              "Welcome to THARKY...".tr().toString(),
              style: boldTextStyle(
                size: 23,
                color: white,
              ),
            ),
            8.height,
            Text(
              // "Up your style, check that vibe, and fix that attitude. Sign up—you’re not VIP yet!"
              "It's OK to be gay"
                  .tr()
                  .toString(),
              style: primaryTextStyle(size: 15, color: white),
            ),
          ],
        ).paddingOnly(left: 20, bottom: 10),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(24, 1, 24, 12),
        decoration: BoxDecoration(
          color: blackColor,
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
            32.height,
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: fNameCont,
              focus: fNameFocus,
              cursorColor: redColor,
              textStyle: primaryTextStyle(color: Colors.white),
              nextFocus: lNameFocus,
              errorThisFieldRequired: "required",
              suffix: ic_profile2
                  .iconImage(padding: 3, color: primaryColor)
                  .paddingAll(14),
              decoration: inputDecoration2(context, labelText: "Firstname"),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.NAME,
              textStyle: primaryTextStyle(color: Colors.white),
              controller: lNameCont,
              cursorColor: redColor,
              focus: lNameFocus,
              errorThisFieldRequired: "required",
              decoration: inputDecoration2(context, labelText: "Lastname"),
              suffix: ic_profile2
                  .iconImage(padding: 3, color: primaryColor)
                  .paddingAll(14),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.EMAIL,
              controller: emailCont,
              textStyle: primaryTextStyle(color: Colors.white),
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
              controller: passwordCont,
              focus: passwordFocus,
              textStyle: primaryTextStyle(color: Colors.white),
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
            AppTextField(
              textFieldType: TextFieldType.PHONE,
              textStyle: primaryTextStyle(color: Colors.white),
              readOnly:
                  widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
              errorThisFieldRequired: "required",
              decoration: inputDecoration2(
                context,
                labelText: "Phone number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensure it doesn't take too much space
                    children: [
                      CountryCodePicker(
                        textStyle: primaryTextStyle(color: Colors.white),
                        flagWidth: 20,
                        padding: EdgeInsets.zero,
                        searchPadding: EdgeInsets.zero,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        onChanged: (value) {
                          setState(() {
                            countryCode = value.dialCode!;
                          });
                        },
                        initialSelection: 'GB',
                        favorite: [countryCode, 'GB'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ],
                  ),
                ),
              ),
              onFieldSubmitted: (s) {
                if (widget.isOTPLogin == false) registerUser();
              },
              controller: phoneNumController,
              onChanged: (value) {
                setState(() {
                  cont = value.length == 10;
                });
              },
            ),
            10.height,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "I forgot my password !".tr().toString(),
                      style: TextStyle(color: whiteColor),
                    ),
                    onTap: () {
                      RessetPass({
                        "email": emailCont.text,
                        "phone": phoneNumController.text
                      }).launch(context);
                    },
                  ),
                ],
              ),
            ),
            10.height,
            _buildTcAcceptWidget(),
            20.height,
            AppButton(
              text: "signup".tr(),
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
                        text: "Already a member ? ",
                        style: secondaryTextStyle(size: 15, color: whiteColor)),
                    TextSpan(
                      text: "Login ",
                      style: secondaryTextStyle(color: primaryColor, size: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          SignInScreen().launch(context);
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
                text: "      We Don’t Do Popups. EVER. \nBut we do have a  ",
                style: secondaryTextStyle(size: 14, color: whiteColor)),
            TextSpan(
              text: "Privacy policy",
              style: secondaryTextStyle(color: primaryColor, size: 15),
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
      backgroundColor: blackColor,
      body: Stack(
        children: [
          // Stack(
          //   children: <Widget>[
          //     Positioned(
          //       top: -circlesize / 1.4,
          //       left: -circlesize / 4,
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
