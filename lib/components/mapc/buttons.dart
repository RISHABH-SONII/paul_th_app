import 'package:flutter/material.dart';

Widget YRoundedButton(
    {Color color = Colors.yellow,
    Color textColor = Colors.black,
    String text = "",
    void Function()? onPressed}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(color),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      minimumSize: WidgetStateProperty.all<Size>(const Size.fromHeight(50)),
      elevation: WidgetStateProperty.all<double>(0),
      shape: WidgetStateProperty.all(const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      )),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 15),
    ),
  );
}

Widget YMaterialRoundedButton(
    {Color color = Colors.yellow, textColor = Colors.black}) {
  return ElevatedButton(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.lime),
      backgroundColor: WidgetStateProperty.all<Color>(color),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      )),
    ),
    onPressed: () async {},
    child: Text('Ajouter'),
  );
}
