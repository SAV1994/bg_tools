import 'package:drift/drift.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/randomizer/list_item.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';
import 'package:bg_tools/core/dataclasses/export.dart';

part 'random_list_dao.g.dart';

@DriftAccessor(tables: [RandomLists, ListItems])
class RandomListDao extends DatabaseAccessor<AppDatabase>
    with _$RandomListDaoMixin {
  RandomListDao(super.db);

  // Создание новой записи
  Future<int> create({
    required RandomListsCompanion randomList,
    required List<ListItemData?> items,
  }) async {
    int randomListId = await into(randomLists).insert(randomList);

    for (final item in items) {
      await into(listItems).insert(
        ListItemsCompanion(
          name: Value(item!.name),
          randomListId: Value(randomListId),
          copiesNum: Value(item.copiesNum),
          imagePath: Value(item.imagePath),
        ),
      );
    }

    return randomListId;
  }

  // Редактирование
  Future<bool> updInstance({
    required int randomListId,
    required RandomListsCompanion randomList,
    required List<ListItemData?> items,
  }) async {
    // 1. Обновляем
    final updateResult = await (update(
      randomLists,
    )..where((rl) => rl.id.equals(randomListId))).write(randomList);
    // 2. Удаляем старые связи
    await (delete(
      listItems,
    )..where((li) => li.randomListId.equals(randomListId))).go();
    // 3. Добавляем новые связи
    for (final item in items) {
      await into(listItems).insert(
        ListItemsCompanion(
          name: Value(item!.name),
          randomListId: Value(randomListId),
          copiesNum: Value(item.copiesNum),
          imagePath: Value(item.imagePath),
        ),
      );
    }

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int randomListId) async {
    return await (delete(
      randomLists,
    )..where((rl) => rl.id.equals(randomListId))).go();
  }

  // Все рандомные списки
  Future<List<RandomList>> getAll() async {
    SimpleSelectStatement<$RandomListsTable, RandomList> query =
        _getBaseQuery();
    return await query.get();
  }

  // Рандомный список
  Future<RandomListData?> get(int randomListId) async {
    RandomList? randomList = await (select(
      randomLists,
    )..where((rl) => rl.id.equals(randomListId))).getSingleOrNull();

    if (randomList != null) {
      List<ListItem?> items = await (select(
        listItems,
      )..where((li) => li.randomListId.equals(randomListId))).get();

      List<ListItemData> itemsList = [];
      for (final item in items) {
        itemsList.add(
          ListItemData(
            id: item!.id,
            name: item.name,
            copiesNum: item.copiesNum,
            imagePath: item.imagePath,
          ),
        );
      }

      return RandomListData(randomList: randomList, items: itemsList);
    } else {
      return null;
    }
  }

  SimpleSelectStatement<$RandomListsTable, RandomList> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(randomLists)..orderBy([
      (t) => OrderingTerm(
        expression: t.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }
}
