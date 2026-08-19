import 'package:bg_tools/core/consts/export.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onPressed;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 30),
        foregroundColor: textColor,
        backgroundColor: secondColor,
        fixedSize: Size(350, 50),
        iconSize: 30,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      label: Row(children: [Text(label), Spacer()]),
      icon: Icon(icon, color: firstColor),
    );
  }
}
