import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/counting_template.dart';
import 'package:bg_tools/core/database/tables/game.dart';

// Junction table для связи Игры <-> Шаблоны подсчёта
class GamesCountingTemplates extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  TextColumn get data => text().nullable()(); // Данные (JSON)
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get countingTemplateId => integer().references(
    CountingTemplates,
    #id,
    onDelete: KeyAction.cascade,
  )();
}
