import 'package:flutter/material.dart';

// Команды для игровой сессии
enum TeamsEnum {
  red(1, 'Красная', Color(0xFFFF5252), Color(0x1FFF5252), Color(0x33FF5252)),
  blue(2, 'Синяя', Color(0xFF42A5F5), Color(0x1F42A5F5), Color(0x3342A5F5)),
  green(3, 'Зеленая', Color(0xFF66BB6A), Color(0x1F66BB6A), Color(0x3366BB6A)),
  purple(
    4,
    'Фиолетовая',
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
