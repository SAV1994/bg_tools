import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/utils/export.dart';

class DateTimeDisplay extends StatelessWidget {
  final DateTime dateTime;
  final DateTime? secondDateTime;
  final bool showTime;
  final bool showSeconds;

  const DateTimeDisplay({
    super.key,
    required this.dateTime,
    this.secondDateTime,
    this.showTime = true,
    this.showSeconds = false,
  });

  String get _formattedDate => DateFormats.formatDate(dateTime);
  String get _formattedTime => DateFormats.formatTime(dateTime);

  @override
  Widget build(BuildContext context) {
    String? duration;
    if (secondDateTime != null) {
      duration = getDuration(dateTime, secondDateTime!);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.blue.shade700,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Дата',
                        style: TextStyle(fontSize: 12, color: titleColor),
                      ),
                      Text(
                        _formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showTime) ...[
              Row(
                spacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Время',
                          style: TextStyle(fontSize: 12, color: titleColor),
                        ),
                        Text(
                          _formattedTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (duration != null)
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.red.shade700,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Продолжительность',
                            style: TextStyle(fontSize: 12, color: titleColor),
                          ),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
