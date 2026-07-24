import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/counting_template.dart';

part 'counting_template_dao.g.dart';

@DriftAccessor(tables: [CountingTemplates])
class CountingTemplateDao extends DatabaseAccessor<AppDatabase>
    with _$CountingTemplateDaoMixin {
  CountingTemplateDao(super.db);

  // Создание новой записи
  Future<int> create(CountingTemplatesCompanion countingTemplate) async {
    return await into(countingTemplates).insert(countingTemplate);
  }

  // Редактирование
  Future<bool> updInstance(
    int countingTemplateId,
    CountingTemplatesCompanion countingTemplate,
  ) async {
    final updateResult = await (update(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).write(countingTemplate);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int countingTemplateId) async {
    return await (delete(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).go();
  }

  // Все шаблоны
  Future<List<CountingTemplate>> getAll() async {
    return await select(countingTemplates).get();
  }

  // Шаблоны с пагинацией
  Future<List<CountingTemplate>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    int? gameTypeId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate> query =
        _getFilteredQuery(
          query: _getBaseQuery(reverse: reverseOrdering),
          gameTypeId: gameTypeId,
          searchQuery: searchQuery,
        )..limit(pageSize, offset: offset);

    return query.get();
  }

  // Общее число шаблонов, соответствующих условию
  Future<int> getTotalCount({int? gameTypeId, String? searchQuery}) async {
    SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate> query =
        select(countingTemplates);
    query = _getFilteredQuery(
      query: query,
      gameTypeId: gameTypeId,
      searchQuery: searchQuery,
    );

    return await query.get().then((list) => list.length);
  }

  // Шаблон
  Future<CountingTemplate?> get(int countingTemplateId) async {
    return await (select(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).getSingleOrNull();
  }

  SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate>
  _getBaseQuery({bool reverse = false}) {
    return select(countingTemplates)..orderBy([
      (ct) => OrderingTerm(
        expression: ct.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate>
  _getFilteredQuery({
    required SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate>
    query,
    int? gameTypeId,
    String? searchQuery,
  }) {
    if (gameTypeId != null) {
      query = query..where((ct) => ct.data.contains('"gameType":$gameTypeId,'));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((ct) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [countingTemplates],
          );
          final lowerDescriptionExpression = CustomExpression<String>(
            'lower_unicode(description)',
            watchedTables: [countingTemplates],
          );
          final searchQueryLower = searchQuery.toLowerCase();

          return lowerNameExpression.like('%$searchQueryLower%') |
              lowerDescriptionExpression.like('%$searchQueryLower%');
        });
    }

    return query;
  }
}
