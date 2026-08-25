import 'package:drift/drift.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/features/export_import_service/services/base_mover.dart';
import 'package:bg_tools/features/export_import_service/services/obj_to_map/export.dart';

class GameTemplateMover extends BaseMover {
  @override
  final int type = ImportTypeEnum.template.id;
  final int gameId;
  final int? gameTemplateId;

  GameTemplateMover({required this.gameId, this.gameTemplateId});

  @override
  Future<Map<String, dynamic>> extractToJson() async {
    final Map<String, dynamic> exportData = {
      importDataVersionCodeKey: '${importDataVersionCode}_$type',
      'countingTemplates': [],
      'gamesCountingTemplates': [],
    };

    if (gameTemplateId != null) {
      final GamesCountingTemplatesDao gamesCountingTemplatesDao = container
          .read(gamesCountingTemplatesDaoProvider);
      final GamesCountingTemplatesData? templateData =
          await gamesCountingTemplatesDao.getSingle(gameTemplateId!);

      exportData['countingTemplates'].add(
        getCountingTemplateData(templateData!.countingTemplate),
      );
      exportData['gamesCountingTemplates'].add(
        getGamesCountingTemplateData(templateData.gamesCountingTemplate),
      );
    }

    return exportData;
  }

  @override
  Future<List<Game>> getExportGames() async {
    return [];
  }

  @override
  String getZipFileNamePrefix() {
    return 'gameTemplate${gameTemplateId}_backup_';
  }

  @override
  Future<void> insertDataToDb(
    AppDatabase database,
    Map<String, String> newImagePaths,
    Map data,
  ) async {
    await database.transaction(() async {
      final countingTemplatesIds = <int, int>{};
      final Map<String, dynamic> countingTemplateJson =
          data['countingTemplates'].first;
      int? id;
      CountingTemplate? countingTemplate =
          await (database.select(database.countingTemplates)
                ..where((ct) => ct.data.equals(countingTemplateJson['data'])))
              .getSingleOrNull();
      if (countingTemplate != null) {
        id = countingTemplate.id;
      } else {
        id = await database
            .into(database.countingTemplates)
            .insert(
              CountingTemplatesCompanion(
                name: Value(countingTemplateJson['name']),
                description: Value(countingTemplateJson['description']),
                data: Value(countingTemplateJson['data']),
              ),
            );
      }

      countingTemplatesIds[countingTemplateJson['id']] = id;

      final Map<String, dynamic> gamesCountingTemplatesJson =
          data['gamesCountingTemplates'].first;
      await database
          .into(database.gamesCountingTemplates)
          .insert(
            GamesCountingTemplatesCompanion(
              name: Value(gamesCountingTemplatesJson['name']),
              data: Value(gamesCountingTemplatesJson['data']),
              gameId: Value(gameId),
              countingTemplateId: Value(
                countingTemplatesIds[gamesCountingTemplatesJson['countingTemplateId']]!,
              ),
            ),
          );
    });
  }
}
