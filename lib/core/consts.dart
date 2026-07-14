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
  red(
    1,
    'Красная команда',
    Color(0xFFFF5252),
    Color(0x1FFF5252),
    Color(0x33FF5252),
  ),
  blue(
    2,
    'Синяя команда',
    Color(0xFF42A5F5),
    Color(0x1F42A5F5),
    Color(0x3342A5F5),
  ),
  green(
    3,
    'Зеленая команда',
    Color(0xFF66BB6A),
    Color(0x1F66BB6A),
    Color(0x3366BB6A),
  ),
  purple(
    4,
    'Фиолетовая команда',
    Color(0xFFAB47BC),
    Color(0x1FAB47BC),
    Color(0x33AB47BC),
  );

  final int id;
  final String label;
  final Color color;
  final Color bgColor;
  final Color bgColorLight;

  const TeamsEnum(
    this.id,
    this.label,
    this.color,
    this.bgColor,
    this.bgColorLight,
  );

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
// Настройки
const String pageLimitKey = 'pageLimit';

// Тема
const Color firstColor = Color(0xFF0A1410);
const Color secondColor = Color(0xFF006B4D);
const Color borderColor = Color(0xFF00E676);
const Color textColor = Color(0xFFF5F5F5);
const Color titleColor = Colors.lightGreenAccent;
const Color shadowColor = Colors.black;
const Color greenColor = Color(0xFF69F0AE);
const Color redColor = Color(0xFFFF5252);
const Color goldColor = Color(0xFFFFD700);
const Color blueColor = Color(0xFF29B6F6);

// Пагинация
const int pageSize = 25;
