import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/randomizer/game_component.dart';
import 'package:bg_tools/core/database/tables/randomizer/list_item.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';
import 'package:bg_tools/core/database/tables/randomizer/saved_setup.dart';
import 'package:bg_tools/core/database/tables/randomizer/saved_setups_lists_items.dart';
import 'package:bg_tools/core/dataclasses/export.dart';

part 'saved_setup_dao.g.dart';

@DriftAccessor(
  tables: [
    SavedSetups,
    SavedSetupsListsItems,
    RandomLists,
    ListItems,
    GameComponents,
  ],
)
class SavedSetupDao extends DatabaseAccessor<AppDatabase>
    with _$SavedSetupDaoMixin {
  SavedSetupDao(super.db);

  // Создание новой записи
  Future<int> create({
    required SavedSetupsCompanion savedSetup,
    required List<SavedListItemInputData> items,
  }) async {
    int savedSetupId = await into(savedSetups).insert(savedSetup);

    List<SavedSetupsListsItemsCompanion> itemCompanions = items
        .map(
          (item) => SavedSetupsListsItemsCompanion(
            savedSetupId: Value(savedSetupId),
            randomListId: Value(item.listId),
            listItemsId: Value(item.listItemId),
            position: Value(item.position),
          ),
        )
        .toList();
    for (final item in itemCompanions) {
      await into(savedSetupsListsItems).insert(item);
    }

    return savedSetupId;
  }

  // Редактирование
  Future<bool> updInstance({
    required int savedSetupId,
    required SavedSetupsCompanion savedSetup,
    required List<SavedListItemInputData> items,
  }) async {
    // 1. Обновляем
    final updateResult = await (update(
      savedSetups,
    )..where((ss) => ss.id.equals(savedSetupId))).write(savedSetup);
    // 2. Удаляем старые связи
    await (delete(
      savedSetupsListsItems,
    )..where((ssli) => ssli.savedSetupId.equals(savedSetupId))).go();
    // 3. Добавляем новые связи
    List<SavedSetupsListsItemsCompanion> itemCompanions = items
        .map(
          (item) => SavedSetupsListsItemsCompanion(
            savedSetupId: Value(savedSetupId),
            randomListId: Value(item.listId),
            listItemsId: Value(item.listItemId),
            position: Value(item.position),
          ),
        )
        .toList();
    for (final item in itemCompanions) {
      await into(savedSetupsListsItems).insert(item);
    }

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int savedSetupId) async {
    return await (delete(
      savedSetups,
    )..where((ss) => ss.id.equals(savedSetupId))).go();
  }

  // Все сохранённые сетапы
  Future<List<SavedSetup>> getAll(int randomSetupId) async {
    SimpleSelectStatement<$SavedSetupsTable, SavedSetup> query = _getBaseQuery(
      randomSetupId: randomSetupId,
    );
    return await query.get();
  }

  // Сохранённый сетап
  Future<SavedSetupData?> get(int savedSetupId) async {
    SavedSetup? savedSetup = await (select(
      savedSetups,
    )..where((ss) => ss.id.equals(savedSetupId))).getSingleOrNull();

    if (savedSetup != null) {
      final SimpleSelectStatement<
        $SavedSetupsListsItemsTable,
        SavedSetupsListsItem
      >
      query = select(savedSetupsListsItems)
        ..where((ssli) => ssli.savedSetupId.equals(savedSetupId));

      final joinedQuery = query.join([
        innerJoin(
          randomLists,
          randomLists.id.equalsExp(savedSetupsListsItems.randomListId),
        ),
        innerJoin(
          listItems,
          listItems.id.equalsExp(savedSetupsListsItems.listItemsId),
        ),
        innerJoin(
          gameComponents,
          gameComponents.id.equalsExp(listItems.componentId),
        ),
      ]);

      final rows = await joinedQuery.get();

      final List<SavedListItemData> items = [];
      for (TypedResult row in rows) {
        final SavedSetupsListsItem savedItem = row.readTable(
          savedSetupsListsItems,
        );
        final RandomList randomList = row.readTable(randomLists);
        final ListItem? listItem = row.readTableOrNull(listItems);
        final GameComponent? component = row.readTableOrNull(gameComponents);

        items.add(
          SavedListItemData(
            id: savedItem.id,
            list: randomList,
            listItem: listItem!,
            component: component!,
            position: savedItem.position,
          ),
        );
      }

      items.sort((a, b) => a.position.compareTo(b.position));

      return SavedSetupData(savedSetup: savedSetup, items: items);
    } else {
      return null;
    }
  }

  SimpleSelectStatement<$SavedSetupsTable, SavedSetup> _getBaseQuery({
    required int randomSetupId,
    bool reverse = false,
  }) {
    return select(savedSetups)
      ..where((ss) => ss.randomSetupId.equals(randomSetupId))
      ..orderBy([
        (t) => OrderingTerm(
          expression: t.name.collate(const Collate('UNICODE_CI')),
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);
  }
}
