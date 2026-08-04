import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/designer.dart';

part 'designer_dao.g.dart';

@DriftAccessor(tables: [Designers])
class DesignerDao extends DatabaseAccessor<AppDatabase>
    with _$DesignerDaoMixin {
  DesignerDao(super.db);

  // Создание новой записи
  Future<int> create(DesignersCompanion designer) async {
    return await into(designers).insert(designer);
  }

  // Редактирование
  Future<bool> updInstance(int designerId, DesignersCompanion designer) async {
    final updateResult = await (update(
      designers,
    )..where((d) => d.id.equals(designerId))).write(designer);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int designerId) async {
    return await (delete(
      designers,
    )..where((d) => d.id.equals(designerId))).go();
  }

  // Все геймдизайнеры
  Future<List<Designer>> getAll() async {
    SimpleSelectStatement<$DesignersTable, Designer> query = _getBaseQuery();
    return await query.get();
  }

  // Геймдизайнеры с пагинацией
  Future<List<Designer>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$DesignersTable, Designer> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get();
  }

  // Общее количество геймдизайнеров, соответствующих условию
  Future<int> getTotalCount({String? searchQuery}) async {
    SimpleSelectStatement<$DesignersTable, Designer> query = select(designers);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Геймдизайнер
  Future<Designer?> get(int designerId) async {
    return await (select(
      designers,
    )..where((d) => d.id.equals(designerId))).getSingleOrNull();
  }

  SimpleSelectStatement<$DesignersTable, Designer> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(designers)..orderBy([
      (d) => OrderingTerm(
        expression: d.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  SimpleSelectStatement<$DesignersTable, Designer> _getFilteredQuery({
    required SimpleSelectStatement<$DesignersTable, Designer> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((d) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [designers],
          );

          return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
        });
    }

    return query;
  }
}
