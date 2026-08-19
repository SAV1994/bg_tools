import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/import_const.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/export_import_service/base_mover.dart';
import 'package:bg_tools/core/services/export_import_service/obj_to_map/export.dart';
import 'package:bg_tools/core/utils/export.dart';

class AllDataMover extends BaseMover {
  final int type = ImportTypeEnum.all.id;

  @override
  Future<Map<String, dynamic>> extractToJson() async {
    final database = container.read(databaseProvider);

    // Получаем все данные из таблиц
    final artists = await database.select(database.artists).get();
    final countingTemplates = await database
        .select(database.countingTemplates)
        .get();
    final designers = await database.select(database.designers).get();
    final tags = await database.select(database.tags).get();
    final gamers = await database.select(database.gamers).get();
    final games = await database.select(database.games).get();
    final expansionsGames = await database
        .select(database.expansionsGames)
        .get();
    final gamesArtists = await database.select(database.gamesArtists).get();
    final gamesCountingTemplates = await database
        .select(database.gamesCountingTemplates)
        .get();
    final gamesCountingTemplateExpansions = await database
        .select(database.gamesCountingTemplatesExpansions)
        .get();
    final gamesDesigners = await database.select(database.gamesDesigners).get();
    final gamesTags = await database.select(database.gamesTags).get();
    final notes = await database.select(database.notes).get();
    final gamingSessions = await database.select(database.gamingSessions).get();
    final gamingSessionsExpansions = await database
        .select(database.gamingSessionsExpansions)
        .get();
    final gamingSessionsGamers = await database
        .select(database.gamingSessionsGamers)
        .get();
    final ratings = await database.select(database.ratings).get();
    final ratingsGames = await database.select(database.ratingsGames).get();

    // Формируем JSON
    final Map<String, dynamic> exportData = {
      importDataVersionCodeKey: '${importDataVersionCode}_$type',
      'type': ImportTypeEnum.all.id,
      'exportDate': DateTime.now().toIso8601String(),
      'artists': artists
          .map((artist) => {'id': artist.id, 'name': artist.name})
          .toList(),
      'countingTemplates': countingTemplates
          .map((countingTemplate) => getCountingTemplateData(countingTemplate))
          .toList(),
      'designers': designers
          .map((disigner) => {'id': disigner.id, 'name': disigner.name})
          .toList(),
      'tags': tags.map((tag) => {'id': tag.id, 'name': tag.name}).toList(),
      'gamers': gamers
          .map(
            (gamer) => {
              'id': gamer.id,
              'username': gamer.username,
              'firstName': gamer.firstName,
              'lastName': gamer.lastName,
              'middleName': gamer.middleName,
              'isOwner': gamer.isOwner,
            },
          )
          .toList(),
      'games': games.map((game) => getGameData(game)).toList(),
      'expansionsGames': expansionsGames
          .map((eg) => {'gameId': eg.gameId, 'expansionId': eg.expansionId})
          .toList(),
      'gamesArtists': gamesArtists
          .map((ga) => {'gameId': ga.gameId, 'artistId': ga.artistId})
          .toList(),
      'gamesCountingTemplates': gamesCountingTemplates
          .map((gct) => getGamesCountingTemplateData(gct))
          .toList(),
      'gamesCountingTemplateExpansions': gamesCountingTemplateExpansions
          .map(
            (gcte) => {
              'gamesCountingTemplateId': gcte.gamesCountingTemplateId,
              'gameId': gcte.gameId,
            },
          )
          .toList(),
      'gameDesigners': gamesDesigners
          .map((gd) => {'gameId': gd.gameId, 'designerId': gd.designerId})
          .toList(),
      'gamesTags': gamesTags
          .map((gt) => {'gameId': gt.gameId, 'tagId': gt.tagId})
          .toList(),
      'notes': notes
          .map(
            (note) => {
              'id': note.id,
              'gameId': note.gameId,
              'title': note.title,
              'content': note.content,
              'createdAt': note.createdAt.toIso8601String(),
              'updatedAt': note.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'gamingSessions': gamingSessions
          .map(
            (gamingSession) => {
              'id': gamingSession.id,
              'gameId': gamingSession.gameId,
              'startedAt': gamingSession.startedAt.toIso8601String(),
              'finishedAt': gamingSession.finishedAt.toIso8601String(),
              'isFinished': gamingSession.isFinished,
              'comment': gamingSession.comment,
              'gameType': gamingSession.gameType,
              'data': gamingSession.data,
              'rootSessionId': gamingSession.rootSessionId,
            },
          )
          .toList(),
      'gamingSessionsExpansions': gamingSessionsExpansions
          .map(
            (ge) => {
              'gamingSessionId': ge.gamingSessionId,
              'gameId': ge.gameId,
            },
          )
          .toList(),
      'gamingSessionsGamers': gamingSessionsGamers
          .map(
            (gg) => {
              'gamingSessionId': gg.gamingSessionId,
              'gamerId': gg.gamerId,
              'score': gg.score,
              'place': gg.place,
              'turnOrder': gg.turnOrder,
              'team': gg.team,
              'data': gg.data,
            },
          )
          .toList(),
      'ratings': ratings
          .map(
            (r) => {
              'id': r.id,
              'year': r.year,
              'month': r.month,
              'isActual': r.isActual,
              'data': r.data,
              'artistId': r.artistId,
              'designerId': r.designerId,
              'tagId': r.tagId,
            },
          )
          .toList(),
      'ratingsGames': ratingsGames
          .map(
            (rg) => {
              'ratingId': rg.ratingId,
              'gameId': rg.gameId,
              'score': rg.score,
              'place': rg.place,
            },
          )
          .toList(),
    };

    return exportData;
  }

  @override
  Future<List<Game>> getExportGames() async {
    final database = container.read(databaseProvider);

    return await database.select(database.games).get();
  }

  @override
  String getZipFileNamePrefix() {
    return 'backup_';
  }

  @override
  Future<void> insertDataToDb(
    AppDatabase database,
    Map<String, String> newImagePaths,
    Map data,
  ) async {
    await database.transaction(() async {
      // Очищаем существующие данные
      await database.delete(database.gamesCountingTemplates).go();
      await database.delete(database.gamesCountingTemplatesExpansions).go();
      await database.delete(database.gamesArtists).go();
      await database.delete(database.gamesDesigners).go();
      await database.delete(database.gamesTags).go();
      await database.delete(database.gamingSessionsExpansions).go();
      await database.delete(database.gamingSessionsGamers).go();
      await database.delete(database.gamingSessions).go();
      await database.delete(database.expansionsGames).go();
      await database.delete(database.ratingsGames).go();
      await database.delete(database.ratings).go();
      await database.delete(database.artists).go();
      await database.delete(database.countingTemplates).go();
      await database.delete(database.designers).go();
      await database.delete(database.tags).go();
      await database.delete(database.gamers).go();
      await database.delete(database.games).go();

      // в AppDataManager тоже
      await AppDataManager.clearLastSessionGamers();
      await AppDataManager.clearLastSessionGamer();
      await AppDataManager.clearActiveSession();
      await AppDataManager.clearLastSessionTeams();
      await AppDataManager.clearRandomGames();
      await AppDataManager.clearRandomPlayers();
      await AppDataManager.clearRatingProcess();

      final artistsIds = <int, int>{};
      for (final artistJson in data['artists']) {
        final id = await database
            .into(database.artists)
            .insert(ArtistsCompanion(name: Value(artistJson['name'])));
        artistsIds[artistJson['id']] = id;
      }

      final countingTemplatesIds = <int, int>{};
      for (final countingTemplateJson in data['countingTemplates']) {
        final id = await database
            .into(database.countingTemplates)
            .insert(
              CountingTemplatesCompanion(
                name: Value(countingTemplateJson['name']),
                description: Value(countingTemplateJson['description']),
                data: Value(countingTemplateJson['data']),
              ),
            );
        countingTemplatesIds[countingTemplateJson['id']] = id;
      }

      final designersIds = <int, int>{};
      for (final designerJson in data['designers']) {
        final id = await database
            .into(database.designers)
            .insert(DesignersCompanion(name: Value(designerJson['name'])));
        designersIds[designerJson['id']] = id;
      }

      final tagsIds = <int, int>{};
      for (final tagJson in data['tags']) {
        final id = await database
            .into(database.tags)
            .insert(TagsCompanion(name: Value(tagJson['name'])));
        tagsIds[tagJson['id']] = id;
      }

      final gamersIds = <int, int>{};
      for (final gamerJson in data['gamers']) {
        final id = await database
            .into(database.gamers)
            .insert(
              GamersCompanion(
                username: Value(gamerJson['username']),
                firstName: Value(gamerJson['firstName']),
                lastName: Value(gamerJson['lastName']),
                middleName: Value(gamerJson['middleName']),
                isOwner: Value(gamerJson['isOwner']),
              ),
            );
        gamersIds[gamerJson['id']] = id;
      }

      final gamesIds = <int, int>{};
      for (final gameJson in data['games']) {
        final String? imagePath = gameJson['imagePath'] != null
            ? newImagePaths[path.basename(gameJson['imagePath'])]
            : null;

        final id = await database
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

      final gamingSessionsIds = <int, int>{};
      final Map<int, List<int>> rootSessionLinks = {};
      for (final gamingSessionJson in data['gamingSessions']) {
        int? rootSessionId;
        if (gamingSessionJson['rootSessionId'] != null &&
            gamingSessionsIds[gamingSessionJson['rootSessionId']] != null) {
          rootSessionId = gamingSessionsIds[gamingSessionJson['rootSessionId']];
        }

        final id = await database
            .into(database.gamingSessions)
            .insert(
              GamingSessionsCompanion(
                gameId: Value(gamesIds[gamingSessionJson['gameId']]!),
                startedAt: Value(
                  DateTime.parse(gamingSessionJson['startedAt']),
                ),
                finishedAt: Value(
                  DateTime.parse(gamingSessionJson['finishedAt']),
                ),
                isFinished: Value(gamingSessionJson['isFinished']),
                comment: Value(gamingSessionJson['comment']),
                gameType: Value(gamingSessionJson['gameType']),
                data: Value(gamingSessionJson['data']),
                rootSessionId: Value(rootSessionId),
              ),
            );
        gamingSessionsIds[gamingSessionJson['id']] = id;

        if (gamingSessionJson['rootSessionId'] != null &&
            rootSessionId == null) {
          addIntToEnsureList(
            rootSessionLinks,
            gamingSessionJson['rootSessionId'],
            id,
          );
        }
      }

      for (final item in rootSessionLinks.entries) {
        await (database.update(
          database.gamingSessions,
        )..where((gs) => gs.id.isIn(item.value))).write(
          GamingSessionsCompanion(
            rootSessionId: Value(gamingSessionsIds[item.key]!),
          ),
        );
      }

      for (final noteJson in data['notes']) {
        await database
            .into(database.notes)
            .insert(
              NotesCompanion(
                gameId: Value(gamesIds[noteJson['gameId']]!),
                title: Value(noteJson['title']),
                content: Value(noteJson['content']),
                createdAt: Value(DateTime.parse(noteJson['createdAt'])),
                updatedAt: Value(DateTime.parse(noteJson['updatedAt'])),
              ),
            );
      }

      final ratingsIds = <int, int>{};
      for (final ratingsJson in data['ratings']) {
        final id = await database
            .into(database.ratings)
            .insert(
              RatingsCompanion(
                year: Value(ratingsJson['year']),
                month: Value(ratingsJson['month']),
                isActual: Value(ratingsJson['isActual']),
                data: Value(ratingsJson['data']),
                artistId: Value(artistsIds[ratingsJson['artistId']]!),
                designerId: Value(designersIds[ratingsJson['designerId']]!),
                tagId: Value(tagsIds[ratingsJson['tagId']]!),
              ),
            );
        ratingsIds[ratingsJson['id']] = id;
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
      for (final gdJson in data['gameDesigners']) {
        await database
            .into(database.gamesDesigners)
            .insert(
              GamesDesignersCompanion(
                gameId: Value(gamesIds[gdJson['gameId']]!),
                designerId: Value(designersIds[gdJson['designerId']]!),
              ),
            );
      }

      for (final gaJson in data['gamesArtists']) {
        await database
            .into(database.gamesArtists)
            .insert(
              GamesArtistsCompanion(
                gameId: Value(gamesIds[gaJson['gameId']]!),
                artistId: Value(artistsIds[gaJson['artistId']]!),
              ),
            );
      }

      for (final gtJson in data['gamesTags']) {
        await database
            .into(database.gamesTags)
            .insert(
              GamesTagsCompanion(
                gameId: Value(gamesIds[gtJson['gameId']]!),
                tagId: Value(tagsIds[gtJson['tagId']]!),
              ),
            );
      }

      for (final gseJson in data['gamingSessionsExpansions']) {
        await database
            .into(database.gamingSessionsExpansions)
            .insert(
              GamingSessionsExpansionsCompanion(
                gamingSessionId: Value(
                  gamingSessionsIds[gseJson['gamingSessionId']]!,
                ),
                gameId: Value(gamesIds[gseJson['gameId']]!),
              ),
            );
      }

      for (final gsgJson in data['gamingSessionsGamers']) {
        await database
            .into(database.gamingSessionsGamers)
            .insert(
              GamingSessionsGamersCompanion(
                gamingSessionId: Value(
                  gamingSessionsIds[gsgJson['gamingSessionId']]!,
                ),
                gamerId: Value(gamersIds[gsgJson['gamerId']]!),
                score: Value(gsgJson['score']),
                place: Value(gsgJson['place']),
                turnOrder: Value(gsgJson['turnOrder']),
                team: Value(gsgJson['team']),
                data: Value(gsgJson['data']),
              ),
            );
      }

      for (final rgJson in data['ratingsGames']) {
        await database
            .into(database.ratingsGames)
            .insert(
              RatingsGamesCompanion(
                ratingId: Value(ratingsIds[rgJson['ratingId']]!),
                gameId: Value(gamesIds[rgJson['gameId']]!),
                score: Value(rgJson['score']),
                place: Value(rgJson['place']),
              ),
            );
      }
    });
  }
}
