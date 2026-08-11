import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/export_import_service/base_mover.dart';
import 'package:bg_tools/core/services/export_import_service/obj_to_map/export.dart';

class GameMover extends BaseMover {
  @override
  final int type = ImportTypeEnum.game.id;
  final int? gameId;

  GameMover({this.gameId});

  @override
  Future<Map<String, dynamic>> extractToJson() async {
    final Map<String, dynamic> exportData = {
      importDataVersionCodeKey: '${importDataVersionCode}_$type',
      'countingTemplates': [],
      'games': [],
      'expansionsGames': [],
      'gamesCountingTemplates': [],
      'gamesCountingTemplateExpansions': [],
    };

    if (gameId != null) {
      final GameDao gameDao = container.read(gameDaoProvider);
      final GamesCountingTemplatesDao gamesCountingTemplatesDao = container
          .read(gamesCountingTemplatesDaoProvider);
      final GameFullData? gameData = await gameDao.getFullInfo(gameId!);
      final List<GamesCountingTemplatesData> templatesData =
          await gamesCountingTemplatesDao.getAll(gameId!);

      for (final GamesCountingTemplatesData templateData in templatesData) {
        exportData['countingTemplates'].add(
          getCountingTemplateData(templateData.countingTemplate),
        );
        exportData['gamesCountingTemplates'].add(
          getGamesCountingTemplateData(templateData.gamesCountingTemplate),
        );
        for (final Game game in templateData.expansions) {
          exportData['gamesCountingTemplateExpansions'].add({
            'gamesCountingTemplateId': templateData.gamesCountingTemplate.id,
            'gameId': game.id,
          });
        }
      }

      exportData['games'].add(getGameData(gameData!.game));
      for (Game game in gameData.expansions) {
        exportData['games'].add(getGameData(game));
        exportData['expansionsGames'].add({
          'gameId': gameData.game.id,
          'expansionId': game.id,
        });
      }
    }

    return exportData;
  }

  @override
  Future<List<Game>> getExportGames() async {
    List<Game> games = [];

    if (gameId != null) {
      final GameDao gameDao = container.read(gameDaoProvider);
      final GameFullData? gameData = await gameDao.getFullInfo(gameId!);
      List<Game> games = gameData!.expansions;
      games.add(gameData.game);
    }

    return games;
  }

  @override
  String getZipFileNamePrefix() {
    return 'game${gameId}_backup_';
  }

  @override
  Future<void> insertDataToDb(
    AppDatabase database,
    Map<String, String> newImagePaths,
    Map data,
  ) async {
    await database.transaction(() async {
      final countingTemplatesIds = <int, int>{};
      for (final countingTemplateJson in data['countingTemplates']) {
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
      }

      final gamesIds = <int, int>{};
      for (final gameJson in data['games']) {
        int? id;
        Game? game = await (database.select(
          database.games,
        )..where((g) => g.name.equals(gameJson['name']))).getSingleOrNull();
        if (game != null) {
          id = game.id;
        } else {
          final String? imagePath = gameJson['imagePath'] != null
              ? newImagePaths[path.basename(gameJson['imagePath'])]
              : null;

          id = await database
              .into(database.games)
              .insert(
                GamesCompanion(
                  name: Value(gameJson['name']),
                  description: Value(gameJson['description']),
                  year: Value(gameJson['year']),
                  minPlayers: Value(gameJson['minPlayers']),
                  maxPlayers: Value(gameJson['maxPlayers']),
                  isInCollection: Value(gameJson['isInCollection']),
                  isFavorite: Value(gameJson['isFavorite']),
                  rating: Value(gameJson['rating']),
                  isStandalone: Value(gameJson['isStandalone'] ?? true),
                  imagePath: Value(imagePath),
                ),
              );
        }

        gamesIds[gameJson['id']] = id;
      }

      final gamesCountingTemplatesIds = <int, int>{};
      for (final gamesCountingTemplatesJson in data['gamesCountingTemplates']) {
        final id = await database
            .into(database.gamesCountingTemplates)
            .insert(
              GamesCountingTemplatesCompanion(
                name: Value(gamesCountingTemplatesJson['name']),
                data: Value(gamesCountingTemplatesJson['data']),
                gameId: Value(gamesIds[gamesCountingTemplatesJson['gameId']]!),
                countingTemplateId: Value(
                  countingTemplatesIds[gamesCountingTemplatesJson['countingTemplateId']]!,
                ),
              ),
            );
        gamesCountingTemplatesIds[gamesCountingTemplatesJson['id']] = id;
      }

      for (final gamesCountingTemplateExpansionsJson
          in data['gamesCountingTemplateExpansions']) {
        await database
            .into(database.gamesCountingTemplatesExpansions)
            .insert(
              GamesCountingTemplatesExpansionsCompanion(
                gamesCountingTemplateId: Value(
                  gamesCountingTemplatesIds[gamesCountingTemplateExpansionsJson['gamesCountingTemplateId']]!,
                ),
                gameId: Value(
                  gamesIds[gamesCountingTemplateExpansionsJson['gameId']]!,
                ),
              ),
            );
      }

      // Импортируем связи
      for (final egJson in data['expansionsGames']) {
        await database
            .into(database.expansionsGames)
            .insert(
              ExpansionsGamesCompanion(
                gameId: Value(gamesIds[egJson['gameId']]!),
                expansionId: Value(gamesIds[egJson['expansionId']]!),
              ),
            );
      }
    });
  }
}
