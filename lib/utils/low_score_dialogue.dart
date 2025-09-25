import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/colors.dart';

class LowScoreDialogue extends StatelessWidget {
  const LowScoreDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2196F3), // Blue
              Color(0xFF21CBF3), // Cyan
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          // color: Colors.blueAccent,
        ),
        child: Text(
          "Improve Your Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins-Regular",
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      content: Text(
        "Only hot profiles earn money. Ensure your photos are the best if you want to make money.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins-Regular",
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                primaryColor.withOpacity(.5),
                primaryColor.withOpacity(.8),
                primaryColor,
                primaryColor,
              ]
            ), // No g
            // gradient: LinearGradient(
            //   colors: [
            //     primaryColor,
            //     primaryColor.withValues(alpha: 0.35),
            //     // Colors.white10
            //     // Color(0xFF2196F3), // Blue
            //     // Color(0xFF21CBF3), // Cyan
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              alignment: Alignment.bottomCenter,
              backgroundColor:Colors.transparent,
              foregroundColor: Colors.white,

              padding: const EdgeInsets.symmetric(
                  vertical: 14), // taller button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight:
                    Radius.circular(25)),
              ),
            ),
            child: const Text(
              "OK",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins-Regular"),
            ),
          ),
        )
      ],
    );
  }
}
