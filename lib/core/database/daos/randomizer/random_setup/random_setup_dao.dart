import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/randomizer/game_component.dart';
import 'package:bg_tools/core/database/tables/randomizer/list_item.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_list.dart';
import 'package:bg_tools/core/database/tables/randomizer/random_setup.dart';
import 'package:bg_tools/core/dataclasses/export.dart';

part 'random_setup_dao.g.dart';

@DriftAccessor(tables: [RandomSetups, RandomLists, ListItems, GameComponents])
class RandomSetupDao extends DatabaseAccessor<AppDatabase>
    with _$RandomSetupDaoMixin {
  RandomSetupDao(super.db);

  // Создание новой записи
  Future<int> create({required RandomSetupsCompanion randomSetup}) async {
    int randomSetupId = await into(randomSetups).insert(randomSetup);

    return randomSetupId;
  }

  // Редактирование
  Future<bool> updInstance({
    required int randomSetupId,
    required RandomSetupsCompanion randomSetup,
  }) async {
    final updateResult = await (update(
      randomSetups,
    )..where((rs) => rs.id.equals(randomSetupId))).write(randomSetup);

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance({required int randomSetupId}) async {
    return await (delete(
      randomSetups,
    )..where((rs) => rs.id.equals(randomSetupId))).go();
  }

  // Все сетапы
  Future<List<RandomSetup>> getAll(int gameId) async {
    return await (_getBaseQuery(gameId: gameId)).get();
  }

  // Сетапы с пагинацией
  Future<List<RandomSetup>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required int gameId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$RandomSetupsTable, RandomSetup> query =
        _getFilteredQuery(
          query: _getBaseQuery(gameId: gameId, reverse: reverseOrdering),
          searchQuery: searchQuery,
        )..limit(pageSize, offset: offset);

    return query.get();
  }

  // Общее число сетапов, соответствующих условию
  Future<int> getTotalCount({required int gameId, String? searchQuery}) async {
    SimpleSelectStatement<$RandomSetupsTable, RandomSetup> query =
        _getBaseQuery(gameId: gameId);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Сетап с данными
  Future<RandomSetupData> get({required int randomSetupId}) async {
    RandomSetup? randomSetup = await (select(
      randomSetups,
    )..where((ct) => ct.id.equals(randomSetupId))).getSingleOrNull();

    final SimpleSelectStatement<$RandomListsTable, RandomList> query = select(
      randomLists,
    )..where((rsl) => rsl.randomSetupId.equals(randomSetupId));

    final joinedQuery = query.join([
      leftOuterJoin(
        listItems,
        listItems.randomListId.equalsExp(randomLists.id),
      ),
      innerJoin(
        gameComponents,
        listItems.componentId.equalsExp(gameComponents.id),
      ),
    ]);

    final rows = await joinedQuery.get();

    final Map<int, dynamic> listsData = {};
    for (TypedResult row in rows) {
      final RandomList randomList = row.readTable(randomLists);
      final ListItem? listItem = row.readTableOrNull(listItems);
      final GameComponent? component = row.readTableOrNull(gameComponents);

      if (listsData[randomList.id] == null) {
        listsData[randomList.id] = {
          'randomList': randomList,
          'ListItems': listItem != null
              ? [
                  {'listItem': listItem, 'component': component},
                ]
              : [],
        };
      } else {
        listsData[randomList.id]['ListItems'].add({
          'listItem': listItem,
          'component': component,
        });
      }
    }

    List<dynamic> lists = listsData.values.toList();

    lists.sort((a, b) {
      final nameA = a['randomList'].name as String;
      final nameB = b['randomList'].name as String;
      return nameA.compareTo(nameB);
    });

    return RandomSetupData(
      randomSetup: randomSetup!,
      randomLists: lists.map((value) {
        value['ListItems'].sort((a, b) {
          final nameA = a['listItem'].name as String;
          final nameB = b['listItem'].name as String;
          return nameA.compareTo(nameB);
        });

        return RandomListData(
          randomList: value['randomList'],
          items: value['ListItems'].map<ListItemData>((val) {
            return ListItemData(
              listItem: val['listItem'],
              component: val['component'],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  SimpleSelectStatement<$RandomSetupsTable, RandomSetup> _getBaseQuery({
    required int gameId,
    bool reverse = false,
  }) {
    return select(randomSetups)
      ..where((rs) => rs.gameId.equals(gameId))
      ..orderBy([
        (rs) => OrderingTerm(
          expression: rs.name.collate(const Collate('UNICODE_CI')),
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);
  }

  SimpleSelectStatement<$RandomSetupsTable, RandomSetup> _getFilteredQuery({
    required SimpleSelectStatement<$RandomSetupsTable, RandomSetup> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((rs) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [randomSetups],
          );

          return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
        });
    }

    return query;
  }
}
