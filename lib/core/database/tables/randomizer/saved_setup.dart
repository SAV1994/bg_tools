import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/random_setup.dart';

/// Таблица Сохранённые сетапы
class SavedSetups extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  TextColumn get description => text().nullable()(); // Описание
  IntColumn get randomSetupId =>
      integer().references(RandomSetups, #id, onDelete: KeyAction.cascade)();
}
