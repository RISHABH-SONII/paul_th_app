import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Tab.dart';
import 'package:tharkyApp/Screens/UserName.dart';
import 'package:tharkyApp/Screens/ageVerification.dart';
import 'package:tharkyApp/Screens/components/bulletPointMaker.dart';
import 'package:tharkyApp/Screens/components/custom_divider.dart';
import 'package:tharkyApp/components/mail_opener.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 40;
    final height = MediaQuery.of(context).size.height / 40;
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
                  title: Text(
                    "Welcome to\nTharky \n– the irreverent, unapologetic, and outrageously cheeky app for influencers, exhibitionists, and digital flirts. Before you unleash your saucy side, there are a few non-negotiables you need to know. We’re a fun-first platform, but we’ve still got boundaries—because no one likes a creep."
                        .tr()
                        .toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "WHO WE ARE".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "Tharky is a playful, adult-themed app designed to help you show off, glow up, and get noticed. We’re a little spicy—but we are not a pr@wn platform. Think teasing, not full frontal."
                        .tr()
                        .toString(),
                    style: TextStyle(fontSize: 17, color: white),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "AGE RESTRICTION".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "You must be 18 or older to join. If you’re underage, go do your homework."
                        .tr()
                        .toString(),
                    style: TextStyle(fontSize: 17, color: white),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "FREE SPEECH, BUT NOT FREE-FOR-ALL".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "We’re a free speech platform. If it’s not illegal, it’s not our issue. You don’t like someone’s profile, opinion, outfit, or attitude? Block them. You’ve all been given block buttons—use them.\n\n 🚫 If you're blocked by more than 5 different users, your account will be banned. Only bad apples get blocked that often. If it happens to you, maybe it’s not them, it’s you."
                        .tr()
                        .toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "CONTENT RULES (Read This Twice)".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We welcome bold, beautiful, suggestive, and risqué content—but we do not allow:"
                            .tr()
                            .toString(),
                        style: TextStyle(
                          color: white,
                          fontSize: 17,
                        ),
                      ),
                      BulletPoint("Sex acts, real or simulated",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint(
                          "Any images showing genitals, anus, or penetrative activity",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint("Hardcore pr@wn of any kind",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint(
                          "Non-consensual, violent, or illegal material",
                          style: TextStyle(color: white, fontSize: 17)),
                      Text(
                        "This applies to your main feed and private albums.",
                        style: TextStyle(
                            color: white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Yes, users pay £1 to view private galleries—but that doesn't mean the rules disappear. Keep it playful, not explicit.",
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "PRIVATE ALBUM ACCESS".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Private albums cost £1 to unlock. This helps:"
                            .tr()
                            .toString(),
                        style: TextStyle(
                          color: white,
                          fontSize: 17,
                        ),
                      ),
                      BulletPoint("Reduce creeps pestering creators",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint("Set clear boundaries",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint("Keep access respectful and intentional",
                          style: TextStyle(color: white, fontSize: 17)),
                      Text(
                        "Once you unlock someone’s album, enjoy the view—but don’t message them weird stuff. Violators will be booted.",
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "RESPECT & CONSENT".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You are on this app to have fun, not to be a nuisance. We don’t tolerate:"
                            .tr()
                            .toString(),
                        style: TextStyle(
                          color: white,
                          fontSize: 17,
                        ),
                      ),
                      BulletPoint("Harassment or bullying",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint("Spam or unwanted sexual messages",
                          style: TextStyle(color: white, fontSize: 17)),
                      BulletPoint('Ignoring someone’s “no"',
                          style: TextStyle(color: white, fontSize: 17)),
                      Text(
                        "Be hot. Be cool. Don’t be gross.",
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "PAYMENTS".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "All purchases, tips, and private album unlocks are handled securely via paymentWall.\nAll sales are final. If you got blocked after paying—well, that’s on you."
                        .tr()
                        .toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "SAFETY & MODERATION".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "We use a combination of moderation tools, reports, and community feedback to keep things under control.\nRepeat reports = review.\nGet blocked by too many users = ban.\nSimple."
                        .tr()
                        .toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "ACCOUNT TERMINATION".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "We reserve the right to ban or remove any account that violates our rules, disrespects users, or gives us the ick. No appeals from serial offenders."
                        .tr()
                        .toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    "CHANGES TO TERMS".tr().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  subtitle: Text(
                    "We might update these Terms. If we do, we’ll let you know. Don’t worry—we’ll keep it short and in plain English."
                        .tr()
                        .toString(),
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "CONTACT US".tr().toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                              "Questions? Complaints? Or just want to say something cheeky?",
                              style: TextStyle(color: white, fontSize: 17)),
                        )),
                        TextSpan(
                          text: "\nEmail: ",
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => MailOpener.openGmailCompose(
                                  email: "nextgendates@gmail.com",
                                  subject: "Support Request",
                                  body: "Hello, I need help with...",

                                ),
                          text: " nextgendates@gmail.com",
                          style: TextStyle(
                              color: deepSkyBlue,
                              fontSize: 17,
                              overflow: TextOverflow.clip),
                        ),
                        TextSpan(
                          text: "\n\nPrivacy-policy: ",
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              commonLaunchUrl(UPDATED_PRIVACY_POLICY_URL,
                                  launchMode: LaunchMode.externalApplication);
                            },
                          text: "Click-here",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: deepSkyBlue,
                              fontSize: 17,
                              overflow: TextOverflow.clip),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDivider(),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "🖤 Be bold, be real, be respectful. And remember: tease don’t traumatise. 🖤",
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 50),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
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
                                  ])),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "GOT IT".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () async {
                        bool isVerified =
                            appStore.isDocumentVerified.validate();
                        if (isVerified) {
                          String displayName =
                              '${appStore.userName.validate()}';
                          if (displayName != "") {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Tabbar(null, null),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => UserName(),
                              ),
                            );
                          }
                        } else {
                          List<CameraDescription> cameras =
                              await availableCameras();
                          CameraDescription frontCamera = cameras.firstWhere(
                            (camera) =>
                                camera.lensDirection == CameraLensDirection.front,
                          );
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  AgeVerificationScreen(frontCamera),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
