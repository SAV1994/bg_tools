import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/theme_consts.dart';

Future<void> selectDateTime({
  required BuildContext context,
  required DateTime? initialDate,
  required Function(DateTime) onSelect,
}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: secondColor),
          ),
        ),
        child: child!,
      );
    },
  );

  if (date == null) return;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(date),
  );
  if (time == null) return;

  final DateTime dateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  onSelect(dateTime);
}
