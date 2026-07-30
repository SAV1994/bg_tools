import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

Widget getPlaceText(int? place, {bool isFinished = true}) {
  final double fontSize = 20;

  if (!isFinished) {
    return Text(
      'Партия не закончена',
      style: TextStyle(color: borderColor, fontSize: fontSize),
    );
  }

  switch (place) {
    case null:
      return Text(
        'Поражение',
        style: TextStyle(color: redColor, fontSize: fontSize),
      );
    case 1:
      return Text(
        '$firstPlaceMedal Победа',
        style: TextStyle(color: goldColor, fontSize: fontSize),
      );
    case 2:
      return Text(
        '$secondPlaceMedal 2 место',
        style: TextStyle(color: silverColor, fontSize: fontSize),
      );
    case 3:
      return Text(
        '$thirdPlaceMedal 3 место',
        style: TextStyle(color: bronzeColor, fontSize: fontSize),
      );
    default:
      return Text('$place место', style: TextStyle(fontSize: fontSize));
  }
}
