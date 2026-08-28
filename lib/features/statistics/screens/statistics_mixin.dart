import 'package:flutter/material.dart';

mixin StatisticsMixin<T extends StatefulWidget> on State<T> {
  late DateTime periodStart;
  late DateTime periodEnd;
  // Загрузка
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    load();
  }

  Future<void> load() async {
    final DateTime now = DateTime.now();
    periodStart = DateTime(now.year, now.month - 1, now.day);
    periodEnd = DateTime(now.year, now.month, now.day);

    await loadData();
  }

  Future<void> loadData();

  List<Color> generateColors(int count) {
    final List<Color> colorPalette = [
      Colors.blue,
      Colors.green,
      Colors.brown,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.pink,
      Colors.grey,
    ];

    // Если игр больше, чем цветов, повторяем с разной прозрачностью
    if (count <= colorPalette.length) {
      return colorPalette.sublist(0, count);
    } else {
      final colors = <Color>[];
      for (int i = 0; i < count; i++) {
        final color = colorPalette[i % colorPalette.length];
        final opacity = 1.0 - (i ~/ colorPalette.length) * 0.15;
        colors.add(color.withValues(alpha: opacity));
      }
      return colors;
    }
  }

  Future<void> selectDate({bool isPeriodEnd = false}) async {
    final DateTime initialDate = isPeriodEnd ? periodEnd : periodStart;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    if (mounted) {
      setState(() {
        if (isPeriodEnd) {
          periodEnd = date;
        } else {
          periodStart = date;
        }
        loadData();
      });
    }
  }
}
