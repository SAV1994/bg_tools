import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:flutter/material.dart';

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
    String? duration = null;
    if (secondDateTime != null) {
      final Duration difference;
      if (dateTime.isBefore(secondDateTime!)) {
        difference = secondDateTime!.difference(dateTime);
      } else {
        difference = dateTime.difference(secondDateTime!);
      }

      // Вычисляем общее количество часов и оставшиеся минуты
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      print(difference);
      duration = '$hours ч. $minutes мин.';
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
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
                            style: TextStyle(fontSize: 12, color: Colors.grey),
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
