import 'package:drift/drift.dart';

/// Таблица Шаблоны подсчёта
class CountingTemplates extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  TextColumn get description => text().nullable()(); // Описание
  TextColumn get data => text()(); // Данные (JSON)
}
