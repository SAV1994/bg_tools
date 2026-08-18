import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/artist.dart';
import 'package:bg_tools/core/database/tables/designer.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

/// Таблица ТОПы настольный игр
class Ratings extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get year => integer().customConstraint(
    'NOT NULL CHECK (month >= 2026 AND month <= 9999)',
  )(); // Год
  IntColumn get month => integer()
      .customConstraint('CHECK (month >= 1 AND month <= 12)')
      .nullable()(); // Месяц
  BoolColumn get isActual => boolean().withDefault(
    const Constant(true),
  )(); // Является актуальным на данный момент
  TextColumn get data => text()(); // Данные (JSON)
  IntColumn get artistId => integer().nullable().references(
    Artists,
    #id,
    onDelete: KeyAction.cascade,
  )(); // Художник
  IntColumn get designerId => integer().nullable().references(
    Designers,
    #id,
    onDelete: KeyAction.cascade,
  )(); // Геймдизайнер
  IntColumn get tagId => integer().nullable().references(
    Tags,
    #id,
    onDelete: KeyAction.cascade,
  )(); // Тэг
}
