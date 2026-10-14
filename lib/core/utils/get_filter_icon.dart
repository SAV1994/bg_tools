import 'package:bg_tools/core/consts/theme_consts.dart';
import 'package:flutter/material.dart';

Icon getFilterIcon({int numActiveFilters = 0}) {
  switch (numActiveFilters) {
    case 0:
      return Icon(Icons.filter_rounded, color: textColor);
    case 1:
      return Icon(Icons.filter_1_rounded, color: goldColor);
    case 2:
      return Icon(Icons.filter_2_rounded, color: goldColor);
    case 3:
      return Icon(Icons.filter_3_rounded, color: goldColor);
    case 4:
      return Icon(Icons.filter_4_rounded, color: goldColor);
    case 5:
      return Icon(Icons.filter_5_rounded, color: goldColor);
    case 6:
      return Icon(Icons.filter_6_rounded, color: goldColor);
    case 7:
      return Icon(Icons.filter_7_rounded, color: goldColor);
    case 8:
      return Icon(Icons.filter_8_rounded, color: goldColor);
    case 9:
      return Icon(Icons.filter_9_rounded, color: goldColor);
    default:
      return Icon(Icons.filter_9_plus_rounded, color: goldColor);
  }
}
