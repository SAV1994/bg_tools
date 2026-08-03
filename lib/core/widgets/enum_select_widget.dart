import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class EnumSelector extends StatelessWidget {
  final String label;
  final Iterable<DropdownMenuItem<Enum>> choices;
  final Enum? selected;
  final ValueChanged<Enum?> onChanged;
  final bool required;

  const EnumSelector({
    super.key,
    required this.label,
    required this.choices,
    required this.selected,
    required this.onChanged,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Enum>(
      dropdownColor: secondColor,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: OutlineInputBorder(),
      ),
      initialValue: selected,
      hint: const Text('Выберите тип'),
      items: [
        if (!required || selected == null)
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
