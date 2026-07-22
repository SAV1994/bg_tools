import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/gamer.dart';

part 'gamer_dao.g.dart';

@DriftAccessor(tables: [Gamers])
class GamerDao extends DatabaseAccessor<AppDatabase> with _$GamerDaoMixin {
  GamerDao(super.db);

  // Создание новой записи
  Future<int> create(GamersCompanion gamer) async {
    return await into(gamers).insert(gamer);
  }

  // Редактирование
  Future<bool> updInstance(int gamerId, GamersCompanion gamer) async {
    final updateResult = await (update(
      gamers,
    )..where((g) => g.id.equals(gamerId))).write(gamer);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int gamerId) async {
    return await (delete(gamers)..where((g) => g.id.equals(gamerId))).go();
  }

  // Все игроки
  Future<List<Gamer>> getAll() async {
    return await (select(gamers)..where((g) => g.isOwner.equals(false))).get();
  }

  // Все игроки, включая владельца приложения
  Future<List<Gamer>> getEverybody() async {
    return await (select(gamers)).get();
  }

  // Игроки по списку с ID
  Future<List<Gamer>> getByIds(List<int> gamerIds) async {
    if (gamerIds.isEmpty) return [];

    return await (select(gamers)..where((g) => g.id.isIn(gamerIds))).get();
  }

  // Игроки с пагинацией
  Future<List<Gamer>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$GamersTable, Gamer> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get();
  }

  // Общее количество игроков, соответствующих условию
  Future<int> getTotalCount({
    bool onlyFavorite = false,
    bool onlyStandalone = false,
    String? searchQuery,
  }) async {
    SimpleSelectStatement<$GamersTable, Gamer> query = _getBaseQuery();
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Игрок
  Future<Gamer?> get(int gamerId) async {
    return await (select(
      gamers,
    )..where((g) => g.id.equals(gamerId))).getSingleOrNull();
  }

  // Владелец приложения
  Future<Gamer?> getOwner() async {
    return await (select(
      gamers,
    )..where((g) => g.isOwner.equals(true))).getSingleOrNull();
  }

  SimpleSelectStatement<$GamersTable, Gamer> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(gamers)
      ..where((g) => g.isOwner.equals(false))
      ..orderBy([
        (g) => OrderingTerm(
          expression: g.username.collate(const Collate('UNICODE_CI')),
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);
  }

  SimpleSelectStatement<$GamersTable, Gamer> _getFilteredQuery({
    required SimpleSelectStatement<$GamersTable, Gamer> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((g) {
          final lowerUsernameExpression = CustomExpression<String>(
            'lower_unicode(username)',
            watchedTables: [gamers],
          );
          final lowerFirstNameExpression = CustomExpression<String>(
            'lower_unicode(first_name)',
            watchedTables: [gamers],
          );
          final lowerLastNameExpression = CustomExpression<String>(
            'lower_unicode(last_name)',
            watchedTables: [gamers],
          );
          final lowerMiddleNameExpression = CustomExpression<String>(
            'lower_unicode(middle_name)',
            watchedTables: [gamers],
          );
          final searchQueryLower = searchQuery.toLowerCase();

          return lowerUsernameExpression.like('%$searchQueryLower%') |
              lowerFirstNameExpression.like('%$searchQueryLower%') |
              lowerLastNameExpression.like('%$searchQueryLower%') |
              lowerMiddleNameExpression.like('%$searchQueryLower%');
        });
    }

    return query;
  }
}
