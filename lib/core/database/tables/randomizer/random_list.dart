import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_setup.dart';

/// Таблица Рандомные списки
class RandomLists extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get randomSetupId => integer().nullable().references(
    RandomSetups,
    #id,
    onDelete: KeyAction.cascade,
  )(); // Сетап
  IntColumn get gameId => integer().nullable().references(
    Games,
    #id,
    onDelete: KeyAction.cascade,
  )(); // Игра
  IntColumn get type => integer()(); // Тип (RandomListTypeEnum)
  BoolColumn get isUnique => boolean().withDefault(
    const Constant(true),
  )(); // Уникальность всех элементов списка
  IntColumn get itemsNum => integer()(); // Количество элементов в списке
}
