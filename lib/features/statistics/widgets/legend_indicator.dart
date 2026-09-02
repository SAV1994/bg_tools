import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class LegendIndicator extends StatelessWidget {
  final String label;
  final Color color;

  const LegendIndicator({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, color: textColor)),
      ],
    );
  }
}
