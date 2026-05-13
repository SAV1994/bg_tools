// Название Приложения
import 'dart:math';

import 'package:flutter/material.dart';

const String appName = 'BGTools';
// Затычка на случай, если поле пустое
const String emptyVal = '—';
// Варианты строк для виджета загрузки
String getLoadingMsg() {
  const List<String> loadingMsgs = [
    'Кидаем кубы...',
    'Изучаем карты...',
    'Даунтайм...',
  ];
  return loadingMsgs[Random().nextInt(loadingMsgs.length)];
}

// Команды для игровой сессии
enum TeamsEnum {
  red(1, 'Красная команда', Colors.red),
  green(2, 'Зеленая команда', Colors.green),
  blue(3, 'Синяя команда', Colors.blue),
  yellow(4, 'Желтая команда', Colors.yellow);

  final int id;
  final String label;
  final Color color;

  const TeamsEnum(this.id, this.label, this.color);

  // Получить enum по id
  static TeamsEnum fromId(int id) {
    return TeamsEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => TeamsEnum.red,
    );
  }

  // Получить enum по названию
  static TeamsEnum fromLabel(String label) {
    return TeamsEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => TeamsEnum.red,
    );
  }
}
