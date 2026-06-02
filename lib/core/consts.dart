// Название Приложения
import 'dart:math';

import 'package:flutter/material.dart';

const String appName = '🎲 BGTools';
// Затычка на случай, если поле пустое
const String emptyVal = '—';
// Варианты строк для виджета загрузки
String getLoadingMsg() {
  const List<String> loadingMsgs = [
    'Кидаем кубы...',
    'Изучаем карты...',
    'Даунтайм...',
    'Паралич анализа. Ждите...',
  ];
  return loadingMsgs[Random().nextInt(loadingMsgs.length)];
}

// Команды для игровой сессии
enum TeamsEnum {
  red(1, 'Красная команда', Colors.red, Color(0xFFEF5350)),
  blue(2, 'Синяя команда', Colors.blue, Color(0xFF42A5F5)),
  green(3, 'Зеленая команда', Colors.green, Color(0xFF66BB6A)),
  purple(4, 'Фиолетовая команда', Colors.purple, Color(0xFFAB47BC));

  final int id;
  final String label;
  final Color color;
  final Color bgColor;

  const TeamsEnum(this.id, this.label, this.color, this.bgColor);

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

// Ключи для данных в shared_preferences
const String sessionKey = 'session';
const String gamersOfLastSessionKey = 'gamersOfLastSession';
const String settingsKey = 'settings';
const String ratingKey = 'rating';
