// ignore_for_file: avoid_dynamic_calls, prefer_typing_uninitialized_variables, inference_failure_on_uninitialized_variable, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:tharkyApp/components/mapc/ProposedPlace/proposed_lieu.dart';
import 'package:tharkyApp/components/mapc/sheet_bars.dart';
import 'package:tharkyApp/components/mapc/home_controller.dart';
import 'package:tharkyApp/res/global_worker.dart';

class HeaderBottomSheetPushOver extends StatelessWidget {
  final HomeController controller;
  final ScrollController pannelScroller;
  final Map<String, dynamic> userData;

  const HeaderBottomSheetPushOver(this.controller,
      {Key? key, required this.pannelScroller, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic sheetBusiness = const SizedBox();
    sheetBusiness =
        ProposedLieu(homeController: controller, userData: userData);

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Container(
          key: ValueKey<YEnumerate>(controller.crossSwitcher.value),
          child: Column(
            children: [
              controller.crossSwitcher.value == YEnumerate.NearestPlace
                  ? sheetOverBar(context)
                  : const SizedBox(),
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1, -1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    )
                  ],
                ),
                child: sheetBusiness as Widget,
              ),
            ],
          ),
        ));
  }
}

class BottomPopover extends StatelessWidget {
  final Widget child;

  const BottomPopover({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context), child],
      ),
    );
  }
}

Widget _buildHandle(BuildContext context) {
  final theme = Theme.of(context);

  return FractionallySizedBox(
    widthFactor: 0.15,
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      height: 5,
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: const BorderRadius.all(Radius.circular(2.5)),
      ),
    ),
  );
}
