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
    return await _getBaseQuery().get();
  }

  // Шаблоны с пагинацией
  Future<List<CountingTemplate>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    int? gameTypeId,
    int? firstPlayerStartTypeId,
    int? resultTypeId,
    int? generalDefeatTypeId,
    int? teamPointTypeId,
    int? pointTypeId,
    int? roundsTypeId,
    int? altVictoryTypeId,
    int? firstPlayerRoundTypeId,
    int? frstPlayerRoundPointTypeId,
    int? sequencePlayersMovesTypeId,
    int? gameHostTypeId,
    int? secretRolesDistributionTypeId,
    int? uniquenessRolesTypeId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate> query =
        _getFilteredQuery(
          query: _getBaseQuery(reverse: reverseOrdering),
          gameTypeId: gameTypeId,
          firstPlayerStartTypeId: firstPlayerStartTypeId,
          resultTypeId: resultTypeId,
          generalDefeatTypeId: generalDefeatTypeId,
          teamPointTypeId: teamPointTypeId,
          pointTypeId: pointTypeId,
          roundsTypeId: roundsTypeId,
          altVictoryTypeId: altVictoryTypeId,
          firstPlayerRoundTypeId: firstPlayerRoundTypeId,
          frstPlayerRoundPointTypeId: frstPlayerRoundPointTypeId,
          sequencePlayersMovesTypeId: sequencePlayersMovesTypeId,
          gameHostTypeId: gameHostTypeId,
          secretRolesDistributionTypeId: secretRolesDistributionTypeId,
          uniquenessRolesTypeId: uniquenessRolesTypeId,
          searchQuery: searchQuery,
        )..limit(pageSize, offset: offset);

    return query.get();
  }

  // Общее число шаблонов, соответствующих условию
  Future<int> getTotalCount({
    int? gameTypeId,
    int? firstPlayerStartTypeId,
    int? resultTypeId,
    int? generalDefeatTypeId,
    int? teamPointTypeId,
    int? pointTypeId,
    int? roundsTypeId,
    int? altVictoryTypeId,
    int? firstPlayerRoundTypeId,
    int? frstPlayerRoundPointTypeId,
    int? sequencePlayersMovesTypeId,
    int? gameHostTypeId,
    int? secretRolesDistributionTypeId,
    int? uniquenessRolesTypeId,
    String? searchQuery,
  }) async {
    SimpleSelectStatement<$CountingTemplatesTable, CountingTemplate> query =
        select(countingTemplates);
    query = _getFilteredQuery(
      query: query,
      gameTypeId: gameTypeId,
      firstPlayerStartTypeId: firstPlayerStartTypeId,
      resultTypeId: resultTypeId,
      generalDefeatTypeId: generalDefeatTypeId,
      teamPointTypeId: teamPointTypeId,
      pointTypeId: pointTypeId,
      roundsTypeId: roundsTypeId,
      altVictoryTypeId: altVictoryTypeId,
      firstPlayerRoundTypeId: firstPlayerRoundTypeId,
      frstPlayerRoundPointTypeId: frstPlayerRoundPointTypeId,
      sequencePlayersMovesTypeId: sequencePlayersMovesTypeId,
      gameHostTypeId: gameHostTypeId,
      secretRolesDistributionTypeId: secretRolesDistributionTypeId,
      uniquenessRolesTypeId: uniquenessRolesTypeId,
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
    int? firstPlayerStartTypeId,
    int? resultTypeId,
    int? generalDefeatTypeId,
    int? teamPointTypeId,
    int? pointTypeId,
    int? roundsTypeId,
    int? altVictoryTypeId,
    int? firstPlayerRoundTypeId,
    int? frstPlayerRoundPointTypeId,
    int? sequencePlayersMovesTypeId,
    int? gameHostTypeId,
    int? secretRolesDistributionTypeId,
    int? uniquenessRolesTypeId,
    String? searchQuery,
  }) {
    if (gameTypeId != null) {
      query = query..where((ct) => ct.data.contains('"gameType":$gameTypeId,'));
    }

    if (firstPlayerStartTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains(
            '"firstPlayerStartType":$firstPlayerStartTypeId,',
          ),
        );
    }

    if (resultTypeId != null) {
      query = query
        ..where((ct) => ct.data.contains('"resultType":$resultTypeId,'));
    }

    if (generalDefeatTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains('"generalDefeatType":$generalDefeatTypeId,'),
        );
    }

    if (teamPointTypeId != null) {
      query = query
        ..where((ct) => ct.data.contains('"teamPointType":$teamPointTypeId,'));
    }

    if (pointTypeId != null) {
      query = query
        ..where((ct) => ct.data.contains('"pointType":$pointTypeId,'));
    }

    if (roundsTypeId != null) {
      query = query
        ..where((ct) => ct.data.contains('"roundsType":$roundsTypeId,'));
    }

    if (altVictoryTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains('"altVictoryType":$altVictoryTypeId,'),
        );
    }

    if (firstPlayerRoundTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains(
            '"firstPlayerRoundType":$firstPlayerRoundTypeId,',
          ),
        );
    }

    if (frstPlayerRoundPointTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains(
            '"frstPlayerRoundPointType":$frstPlayerRoundPointTypeId,',
          ),
        );
    }

    if (sequencePlayersMovesTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains(
            '"sequencePlayersMovesType":$sequencePlayersMovesTypeId,',
          ),
        );
    }

    if (gameHostTypeId != null) {
      query = query
        ..where((ct) => ct.data.contains('"gameHostType":$gameHostTypeId,'));
    }

    if (secretRolesDistributionTypeId != null) {
      query = query
        ..where(
          (ct) => ct.data.contains(
            '"secretRolesDistributionType":$secretRolesDistributionTypeId,',
          ),
        );
    }

    if (uniquenessRolesTypeId != null) {
      query = query
        ..where(
          (ct) =>
              ct.data.contains('"uniquenessRolesType":$uniquenessRolesTypeId,'),
        );
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
