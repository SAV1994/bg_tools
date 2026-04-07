import 'package:flutter/material.dart';

Widget buildCheckboxView(bool isActive) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isActive ? Colors.green.shade50 : Colors.red.shade50,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isActive ? Colors.green.shade200 : Colors.red.shade200,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isActive ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isActive ? Colors.green : Colors.red,
        ),
      ],
    ),
  );
}
