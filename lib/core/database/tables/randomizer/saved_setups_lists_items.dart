import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/list_item.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';
import 'package:bg_tools/core/database/tables/randomizer/saved_setup.dart';

// Junction table для связи Рандомные сетапы <-> Элементы списков
class SavedSetupsListsItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get savedSetupId => integer().nullable().references(
    SavedSetups,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get randomListId =>
      integer().references(RandomLists, #id, onDelete: KeyAction.cascade)();
  IntColumn get listItemsId =>
      integer().references(ListItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()(); // Порядковый номер
}
