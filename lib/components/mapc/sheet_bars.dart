import 'package:flutter/material.dart';

Widget sheetOverBar(BuildContext context) {
  final theme = Theme.of(context);
  return Transform.translate(
    offset: const Offset(0, -2),
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 5,
      width: 35,
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: BorderRadius.all(Radius.circular(2.5)),
      ),
    ),
  );
}

Widget sheetUnderBar(BuildContext context) {
  final theme = Theme.of(context);
  return Transform.translate(
    offset: const Offset(0, -17),
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 5,
      width: 35,
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: BorderRadius.all(Radius.circular(2.5)),
      ),
    ),
  );
}
