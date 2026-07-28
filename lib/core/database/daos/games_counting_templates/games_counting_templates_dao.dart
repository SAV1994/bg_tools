import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/games_counting_templates.dart';
import 'package:bg_tools/core/database/tables/games_counting_templates_expansions.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';

part 'games_counting_templates_dao.g.dart';

@DriftAccessor(
  tables: [GamesCountingTemplates, GamesCountingTemplatesExpansions],
)
class GamesCountingTemplatesDao extends DatabaseAccessor<AppDatabase>
    with _$GamesCountingTemplatesDaoMixin {
  GamesCountingTemplatesDao(super.db);

  // Создать шаблон партии игры
  Future<int> create(
    GamesCountingTemplatesCompanion companion,
    Set<int> expansionIds,
  ) async {
    final int gamesCountingTemplateId = await into(
      gamesCountingTemplates,
    ).insert(companion);

    for (final expansionId in expansionIds) {
      await into(gamesCountingTemplatesExpansions).insert(
        GamesCountingTemplatesExpansionsCompanion(
          gamesCountingTemplateId: Value(gamesCountingTemplateId),
          gameId: Value(expansionId),
        ),
      );
    }

    return gamesCountingTemplateId;
  }

  // Обновить шаблон партии игры
  Future<bool> updInstance(
    int id,
    GamesCountingTemplatesCompanion companion,
    Set<int> expansionIds,
  ) async {
    return await transaction(() async {
      // 1. Обновляем
      final updateResult = await (update(
        gamesCountingTemplates,
      )..where((gct) => gct.id.equals(id))).write(companion);

      // 2. Удаляем старые связи
      await (delete(
        gamesCountingTemplatesExpansions,
      )..where((gcte) => gcte.gamesCountingTemplateId.equals(id))).go();

      // 3. Добавляем новые связи
      for (final expansionId in expansionIds) {
        await into(gamesCountingTemplatesExpansions).insert(
          GamesCountingTemplatesExpansionsCompanion(
            gamesCountingTemplateId: Value(id),
            gameId: Value(expansionId),
          ),
        );
      }

      return updateResult > 0;
    });
  }

  // Удалить шаблон партии игры
  Future<void> delInstance(int id) async {
    await (delete(
      gamesCountingTemplates,
    )..where((gct) => gct.id.equals(id))).go();
  }

  // Дополнения, указанные в шаблоне
  Future<List<Game>> getExpansions(int gamesCountingTemplateId) async {
    final query =
        select(games).join([
          innerJoin(
            gamesCountingTemplatesExpansions,
            gamesCountingTemplatesExpansions.gameId.equalsExp(games.id),
          ),
        ])..where(
          gamesCountingTemplatesExpansions.gamesCountingTemplateId.equals(
            gamesCountingTemplateId,
          ),
        );

    final results = await query.get();

    return results.map((row) => row.readTable(games)).toList();
  }

  // Cписок шаблонов партии игры
  Future<List<GamesCountingTemplatesData>> getAll(int gameId) async {
    List<GamesCountingTemplatesData> result = [];
    final query = _getBaseQuery(gameId: gameId);
    final joinedQuery = query.join([
      innerJoin(
        countingTemplates,
        countingTemplates.id.equalsExp(
          gamesCountingTemplates.countingTemplateId,
        ),
      ),
    ]);

    final rows = await joinedQuery.get();
    for (final row in rows) {
      final GamesCountingTemplate gamesCountingTemplate = row.readTable(
        gamesCountingTemplates,
      );
      final CountingTemplate countingTemplate = row.readTable(
        countingTemplates,
      );

      final expansions = await getExpansions(gamesCountingTemplate.id);
      final selectedExpansionIds = expansions.map((d) => d.id).toSet();

      result.add(
        GamesCountingTemplatesData(
          gamesCountingTemplate: gamesCountingTemplate,
          countingTemplate: countingTemplate,
          expansions: expansions,
          selectedexpansionIds: selectedExpansionIds,
        ),
      );
    }

    return result;
  }

  // Шаблоны партии игры с пагинацией
  Future<List<GamesCountingTemplatesData>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required int gameId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;
    List<GamesCountingTemplatesData> result = [];

    SimpleSelectStatement query = _getFilteredQuery(
      query: _getBaseQuery(gameId: gameId, reverse: reverseOrdering),
      searchQuery: searchQuery,
    )..limit(pageSize, offset: offset);
    final joinedQuery = query.join([
      innerJoin(
        countingTemplates,
        countingTemplates.id.equalsExp(
          gamesCountingTemplates.countingTemplateId,
        ),
      ),
    ]);

    final rows = await joinedQuery.get();
    for (final row in rows) {
      final GamesCountingTemplate gamesCountingTemplate = row.readTable(
        gamesCountingTemplates,
      );
      final CountingTemplate countingTemplate = row.readTable(
        countingTemplates,
      );

      final expansions = await getExpansions(gamesCountingTemplate.id);
      final selectedExpansionIds = expansions.map((d) => d.id).toSet();

      result.add(
        GamesCountingTemplatesData(
          gamesCountingTemplate: gamesCountingTemplate,
          countingTemplate: countingTemplate,
          expansions: expansions,
          selectedexpansionIds: selectedExpansionIds,
        ),
      );
    }

    return result;
  }

  // Общее число шаблонов партии игры, соответствующих условию
  Future<int> getTotalCount({required int gameId, String? searchQuery}) async {
    SimpleSelectStatement<$GamesCountingTemplatesTable, GamesCountingTemplate>
    query = _getBaseQuery(gameId: gameId);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Общее число шаблонов партии игр, использующих шаблон
  Future<int> getGamesTemplateCount(int countingTemplateId) async {
    SimpleSelectStatement<$GamesCountingTemplatesTable, GamesCountingTemplate>
    query = select(gamesCountingTemplates)
      ..where((gct) => gct.countingTemplateId.equals(countingTemplateId));

    return await query.get().then((list) => list.length);
  }

  // Удалить шаблоны партии игр, использующие шаблон
  Future<void> delByTemplate(int countingTemplateId) async {
    await (delete(
      gamesCountingTemplates,
    )..where((gct) => gct.countingTemplateId.equals(countingTemplateId))).go();
  }

  // Шаблон партии игры
  Future<GamesCountingTemplatesData?> getSingle(
    int gamesCountingTemplatesId,
  ) async {
    final query = (select(gamesCountingTemplates).join([
      innerJoin(
        countingTemplates,
        countingTemplates.id.equalsExp(
          gamesCountingTemplates.countingTemplateId,
        ),
      ),
    ])..where(gamesCountingTemplates.id.equals(gamesCountingTemplatesId)));

    final TypedResult? result = await query.getSingleOrNull();

    if (result == null) return null;

    final GamesCountingTemplate gamesCountingTemplate = result.readTable(
      gamesCountingTemplates,
    );
    final CountingTemplate countingTemplate = result.readTable(
      countingTemplates,
    );
    final expansions = await getExpansions(gamesCountingTemplate.id);
    final selectedExpansionIds = expansions.map((d) => d.id).toSet();

    return GamesCountingTemplatesData(
      gamesCountingTemplate: gamesCountingTemplate,
      countingTemplate: countingTemplate,
      expansions: expansions,
      selectedexpansionIds: selectedExpansionIds,
    );
  }

  SimpleSelectStatement<$GamesCountingTemplatesTable, GamesCountingTemplate>
  _getBaseQuery({required int gameId, bool reverse = false}) {
    return select(gamesCountingTemplates)
      ..where((gct) => gct.gameId.equals(gameId))
      ..orderBy([
        (gct) => OrderingTerm(
          expression: gct.name.collate(const Collate('UNICODE_CI')),
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);
  }

  SimpleSelectStatement<$GamesCountingTemplatesTable, GamesCountingTemplate>
  _getFilteredQuery({
    required SimpleSelectStatement<
      $GamesCountingTemplatesTable,
      GamesCountingTemplate
    >
    query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((gct) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(games_counting_templates.name)',
            watchedTables: [gamesCountingTemplates],
          );
          final searchQueryLower = searchQuery.toLowerCase();

          return lowerNameExpression.like('%$searchQueryLower%');
        });
    }

    return query;
  }
}
