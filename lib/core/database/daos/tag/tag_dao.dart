import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  // Создание новой записи
  Future<int> create(TagsCompanion tag) async {
    return await into(tags).insert(tag);
  }

  // Редактирование
  Future<bool> updInstance(int tagId, TagsCompanion tag) async {
    final updateResult = await (update(
      tags,
    )..where((t) => t.id.equals(tagId))).write(tag);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int tagId) async {
    return await (delete(tags)..where((t) => t.id.equals(tagId))).go();
  }

  // Все метки
  Future<List<Tag>> getAll() async {
    return await select(tags).get();
  }

  // Все метки (поток)
  Stream<List<Tag>> watchAll() {
    return select(tags).watch();
  }

  // Метки с пагинацией
  Future<List<Tag>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$TagsTable, Tag> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get();
  }

  // Общее количество меток, соответствующих условию
  Future<int> getTotalCount({String? searchQuery}) async {
    SimpleSelectStatement<$TagsTable, Tag> query = select(tags);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Метка
  Future<Tag?> get(int tagId) async {
    return await (select(
      tags,
    )..where((t) => t.id.equals(tagId))).getSingleOrNull();
  }

  SimpleSelectStatement<$TagsTable, Tag> _getBaseQuery({bool reverse = false}) {
    return select(tags)..orderBy([
      (t) => OrderingTerm(
        expression: t.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  SimpleSelectStatement<$TagsTable, Tag> _getFilteredQuery({
    required SimpleSelectStatement<$TagsTable, Tag> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((t) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [tags],
          );

          return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
        });
    }

    return query;
  }
}
