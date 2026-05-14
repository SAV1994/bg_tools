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

  JoinedSelectStatement<HasResultSet, dynamic> _getQuery(int gameId) {
    return (select(gamesCountingTemplates).join([
      innerJoin(
        countingTemplates,
        countingTemplates.id.equalsExp(
          gamesCountingTemplates.countingTemplateId,
        ),
      ),
    ])..where(gamesCountingTemplates.gameId.equals(gameId)));
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
    final query = _getQuery(gameId);

    final rows = await query.get();
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

  // Cписок шаблонов партии игры (поток)
  Stream<List<GamesCountingTemplatesData>> watchAll(int gameId) {
    final query = _getQuery(gameId);
    List<GamesCountingTemplatesData> result = [];
    return query.watch().asyncMap((rows) async {
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
    });
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
}
