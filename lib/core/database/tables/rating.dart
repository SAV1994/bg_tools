import 'package:drift/drift.dart';

/// Таблица ТОПы настольный игр
class Ratings extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get year => integer().customConstraint(
    'CHECK (month >= 2026 AND month <= 9999)',
  )(); // Год
  IntColumn get month => integer()
      .customConstraint('CHECK (month >= 1 AND month <= 12)')
      .nullable()(); // Месяц
  TextColumn get data => text()(); // Данные (JSON)
}
