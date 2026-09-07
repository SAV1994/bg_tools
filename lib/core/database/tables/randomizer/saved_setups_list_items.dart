import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/list_item.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_setups_lists.dart';
import 'package:bg_tools/core/database/tables/randomizer/saved_setup.dart';

// Junction table для связи Рандомные сетапы <-> Элементы списков
class SavedSetupsListItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get savedSetupId =>
      integer().references(SavedSetups, #id, onDelete: KeyAction.cascade)();
  IntColumn get randomSetupListId => integer().references(
    RandomSetupsLists,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get listItemsId =>
      integer().references(ListItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()(); // Порядковый номер
}
