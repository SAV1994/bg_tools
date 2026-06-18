// Название Приложения
import 'dart:math';

import 'package:flutter/material.dart';

const String appName = '🎲 BGTools';
// Условное число обозначающее неограниченное количество раундов
const int infNumRounds = 999999;
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
  red(1, 'Красная команда', Colors.red, Color.fromRGBO(255, 158, 158, 1)),
  blue(2, 'Синяя команда', Colors.blue, Color.fromARGB(255, 149, 207, 255)),
  green(3, 'Зеленая команда', Colors.green, Color.fromARGB(255, 160, 255, 165)),
  purple(
    4,
    'Фиолетовая команда',
    Colors.purple,
    Color.fromARGB(255, 239, 147, 255),
  );

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
const String teamssOfLastSessionKey = 'teamssOfLastSession';
const String settingsKey = 'settings';
const String ratingKey = 'rating';

// Тема
const firstColor = Colors.black;
const secondColor = Color.fromARGB(255, 0, 45, 1);
const borderColor = Colors.green;
const textColor = Colors.white70;
