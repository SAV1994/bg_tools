import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_setup.dart';

// Junction table для связи Рандомные сетапы <-> Рандомные списки
class RandomSetupsLists extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get randomSetupId =>
      integer().references(RandomSetups, #id, onDelete: KeyAction.cascade)();
  IntColumn get randomListId =>
      integer().references(RandomLists, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isUnique => boolean().withDefault(
    const Constant(true),
  )(); // Уникальность всех элементов списка
  IntColumn get itemsNum => integer()(); // Количество элементов в списке

  // Составной первичный ключ, чтобы избежать дублирования
  Set<Column> get unique => {name, randomSetupId};
}
