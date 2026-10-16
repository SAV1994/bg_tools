import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/image_service.dart';
import 'package:bg_tools/features/export_import_service/services/base_mover.dart';
import 'package:bg_tools/features/export_import_service/services/obj_to_map/export.dart';

class GameMover extends BaseMover {
  @override
  final int type = ImportTypeEnum.game.id;
  final int? gameId;

  GameMover({this.gameId, required super.ref});

  @override
  Future<Map<String, dynamic>> extractToJson() async {
    final Map<String, dynamic> exportData = {
      importDataVersionCodeKey: '${importDataVersionCode}_$type',
      'countingTemplates': [],
      'games': [],
      'expansionsGames': [],
      'gamesCountingTemplates': [],
      'gamesCountingTemplateExpansions': [],
      'componentTypes': [],
      'gameComponents': [],
      'randomSetups': [],
      'randomLists': [],
      'listItems': [],
      'savedSetups': [],
      'savedSetupsListsItems': [],
    };

    if (gameId != null) {
      final GameDao gameDao = ref.read(gameDaoProvider);
      final GamesCountingTemplatesDao gamesCountingTemplatesDao = ref.read(
        gamesCountingTemplatesDaoProvider,
      );
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

      final ComponentTypeDao componentTypeDao = ref.read(
        componentTypeDaoProvider,
      );
      final List<ComponentTypeData> componentTypesData = await componentTypeDao
          .getAll(gameId!);
      for (final ComponentTypeData componentTypeData in componentTypesData) {
        exportData['componentTypes'].add(
          getComponentTypeData(componentTypeData.componentType),
        );
        for (final GameComponent gameComponent
            in componentTypeData.components) {
          exportData['gameComponents'].add(getGameComponentData(gameComponent));
        }
      }

      final RandomSetupDao randomSetupDao = ref.read(randomSetupDaoProvider);
      final SavedSetupDao savedSetupDao = ref.read(savedSetupDaoProvider);
      final List<RandomSetup> setups = await randomSetupDao.getAll(gameId!);
      for (final RandomSetup setup in setups) {
        final RandomSetupData setupData = await randomSetupDao.get(
          randomSetupId: setup.id,
        );
        exportData['randomSetups'].add(getRandomSetupData(setup));
        for (final RandomListData randomListData in setupData.randomLists) {
          exportData['randomLists'].add(
            getRandomListData(randomListData.randomList),
          );
          for (final ListItemData listItemData in randomListData.items) {
            exportData['listItems'].add(getListItemData(listItemData.listItem));
          }
        }

        final List<SavedSetup> savedSetups = await savedSetupDao.getAll(
          setup.id,
        );
        for (final SavedSetup savedSetup in savedSetups) {
          exportData['savedSetups'].add(getSavedSetupData(savedSetup));
          final SavedSetupData? savedSetupData = await savedSetupDao.get(
            savedSetup.id,
          );
          for (final SavedListItemData savedListItemData
              in savedSetupData!.items) {
            exportData['savedSetupsListsItems'].add({
              'id': savedListItemData.id,
              'savedSetupId': savedSetup.id,
              'randomListId': savedListItemData.listItem.randomListId,
              'listItemsId': savedListItemData.listItem.id,
              'position': savedListItemData.position,
            });
          }
        }
      }
    }

    return exportData;
  }

  @override
  Future<void> exportImages(Directory exportDir) async {
    await super.exportImages(exportDir);

    final ComponentTypeDao componentTypeDao = ref.read(
      componentTypeDaoProvider,
    );

    final componentsImagesDir = Directory(
      path.join(exportDir.path, 'components_images'),
    );
    await componentsImagesDir.create();

    final List<ComponentTypeData> componentTypesData = await componentTypeDao
        .getAll(gameId!);
    for (final ComponentTypeData componentTypeData in componentTypesData) {
      for (final GameComponent component in componentTypeData.components) {
        if (component.imagePath != null && component.imagePath!.isNotEmpty) {
          final sourceFile = await ImageService.getImageFile(
            component.imagePath!,
          );
          if (sourceFile != null) {
            await sourceFile.copy(
              path.join(
                componentsImagesDir.path,
                path.basename(component.imagePath!),
              ),
            );
          }
        }
      }
    }
  }

  @override
  Future<List<Game>> getExportGames() async {
    List<Game> games = [];

    if (gameId != null) {
      final GameDao gameDao = ref.read(gameDaoProvider);
      final GameFullData? gameData = await gameDao.getFullInfo(gameId!);
      games = gameData!.expansions;
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
        List<CountingTemplate> countingTemplate = await (database.select(
          database.countingTemplates,
        )..where((ct) => ct.data.equals(countingTemplateJson['data']))).get();
        if (countingTemplate.isNotEmpty) {
          id = countingTemplate.first.id;
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

      final randomSetupsIds = <int, int>{};
      for (final randomSetupJson in data['randomSetups'] ?? []) {
        final id = await database
            .into(database.randomSetups)
            .insert(
              RandomSetupsCompanion(
                name: Value(randomSetupJson['name']),
                gameId: Value(gamesIds[randomSetupJson['gameId']]!),
              ),
            );
        randomSetupsIds[randomSetupJson['id']] = id;
      }

      final randomListsIds = <int, int>{};
      for (final randomListJson in data['randomLists'] ?? []) {
        int? randomSetupId;
        if (randomListJson['randomSetupId'] != null &&
            randomSetupsIds[randomListJson['randomSetupId']] != null) {
          randomSetupId = randomSetupsIds[randomListJson['randomSetupId']];
        }

        int? gameId;
        if (randomListJson['gameId'] != null &&
            gamesIds[randomListJson['gameId']] != null) {
          gameId = gamesIds[randomListJson['gameId']];
        }

        final id = await database
            .into(database.randomLists)
            .insert(
              RandomListsCompanion(
                name: Value(randomListJson['name']),
                randomSetupId: Value(randomSetupId),
                gameId: Value(gameId),
                type: Value(randomListJson['type']),
                isUnique: Value(randomListJson['isUnique']),
                itemsNum: Value(randomListJson['itemsNum']),
              ),
            );
        randomListsIds[randomListJson['id']] = id;
      }

      final componentTypesIds = <int, int>{};
      for (final componentTypeJson in data['componentTypes'] ?? []) {
        final id = await database
            .into(database.componentTypes)
            .insert(
              ComponentTypesCompanion(
                name: Value(componentTypeJson['name']),
                gameId: Value(gamesIds[componentTypeJson['gameId']]!),
              ),
            );
        componentTypesIds[componentTypeJson['id']] = id;
      }

      final gameComponentsIds = <int, int>{};
      for (final gameComponentJson in data['gameComponents'] ?? []) {
        final String? imagePath = gameComponentJson['imagePath'] != null
            ? newImagePaths[path.basename(gameComponentJson['imagePath'])]
            : null;

        final id = await database
            .into(database.gameComponents)
            .insert(
              GameComponentsCompanion(
                name: Value(gameComponentJson['name']),
                componentTypeId: Value(
                  componentTypesIds[gameComponentJson['componentTypeId']]!,
                ),
                imagePath: Value(imagePath),
              ),
            );
        gameComponentsIds[gameComponentJson['id']] = id;
      }

      final listItemsIds = <int, int>{};
      for (final listItemJson in data['listItems'] ?? []) {
        int? componentId;
        if (listItemJson['componentId'] != null &&
            gameComponentsIds[listItemJson['componentId']] != null) {
          componentId = gameComponentsIds[listItemJson['componentId']];
        }

        final id = await database
            .into(database.listItems)
            .insert(
              ListItemsCompanion(
                name: Value(listItemJson['name']),
                componentId: Value(componentId),
                randomListId: Value(
                  randomListsIds[listItemJson['randomListId']]!,
                ),
                copiesNum: Value(listItemJson['copiesNum']),
              ),
            );
        listItemsIds[listItemJson['id']] = id;
      }

      final savedSetupsIds = <int, int>{};
      for (final savedSetupJson in data['savedSetups'] ?? []) {
        final id = await database
            .into(database.savedSetups)
            .insert(
              SavedSetupsCompanion(
                name: Value(savedSetupJson['name']),
                description: Value(savedSetupJson['description']),
                randomSetupId: Value(
                  randomSetupsIds[savedSetupJson['randomSetupId']]!,
                ),
              ),
            );
        savedSetupsIds[savedSetupJson['id']] = id;
      }

      for (final savedSetupsListItemJson
          in data['savedSetupsListsItems'] ?? []) {
        await database
            .into(database.savedSetupsListsItems)
            .insert(
              SavedSetupsListsItemsCompanion(
                savedSetupId: Value(
                  savedSetupsIds[savedSetupsListItemJson['savedSetupId']]!,
                ),
                randomListId: Value(
                  randomListsIds[savedSetupsListItemJson['randomListId']]!,
                ),
                listItemsId: Value(
                  listItemsIds[savedSetupsListItemJson['listItemsId']]!,
                ),
                position: Value(savedSetupsListItemJson['position']),
              ),
            );
      }
    });
  }
}
