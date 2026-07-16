import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class EnumSelector extends StatelessWidget {
  final String label;
  final Iterable<DropdownMenuItem<Enum>> choices;
  final Enum? selected;
  final ValueChanged<Enum?> onChanged;

  const EnumSelector({
    super.key,
    required this.label,
    required this.choices,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Enum>(
      dropdownColor: secondColor,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      initialValue: selected,
      hint: const Text('Выберите тип'),
      items: [
        // Пустое значение (null)
        const DropdownMenuItem(
          value: null,
          child: Row(
            children: [
              Icon(Icons.clear, size: 18, color: textColor),
              SizedBox(width: 8),
              Text('Не выбрано', style: TextStyle(color: redColor)),
            ],
          ),
        ),

        // Остальные значения
        ...choices,
      ],
      onChanged: onChanged,
    );
  }
}
