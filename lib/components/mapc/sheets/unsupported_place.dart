import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/components/mapc/buttons.dart';
import 'package:tharkyApp/utils/utls.dart';

class UnsupportedPleceSheet extends StatelessWidget {
  final void Function() onModify;
  const UnsupportedPleceSheet({Key? key, required this.onModify})
      : super(key: key);

  void onOriginChanged(String value) {}

  void onDestinationChanged(String value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "excluded_region".tr,
              style: const TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FractionallySizedBox(
              widthFactor: .97,
              child: YRoundedButton(
                  text: "address_another".tr,
                  onPressed: () {
                    my_print("text");
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
