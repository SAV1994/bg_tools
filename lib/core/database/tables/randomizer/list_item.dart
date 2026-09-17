import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/game_component.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';

/// Таблица Элементы списков
class ListItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get componentId => integer().nullable().references(
    GameComponents,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get randomListId =>
      integer().references(RandomLists, #id, onDelete: KeyAction.cascade)();
  IntColumn get copiesNum => integer()(); // Количество копий в пуле

  @override
  List<Set<Column>> get uniqueKeys => [
    {name, randomListId},
  ];
}
