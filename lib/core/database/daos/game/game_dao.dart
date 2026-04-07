import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/games_artists.dart';
import 'package:bg_tools/core/database/tables/games_designers.dart';
import 'package:bg_tools/core/database/tables/games_tags.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [Games, GamesDesigners, GamesArtists, GamesTags])
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);
  
  // Создание новой записи
  Future<int> create(
      GamesCompanion game,
      Set<int> designersIds,
      Set<int> artisrsIds,
      Set<int> tagsIds,
    ) async {
    int gameId = await into(games).insert(game);

    for (final designerId in designersIds) {
      await into(gamesDesigners).insert(
        GamesDesignersCompanion(
          gameId: Value(gameId),
          designerId: Value(designerId),
        ),
      );
    }

    for (final artistId in artisrsIds) {
      await into(gamesArtists).insert(
        GamesArtistsCompanion(
          gameId: Value(gameId),
          artistId: Value(artistId),
        ),
      );
    }

    for (final tagId in tagsIds) {
      await into(gamesTags).insert(
        GamesTagsCompanion(
          gameId: Value(gameId),
          tagId: Value(tagId),
        ),
      );
    }

    return gameId;
  }

  // Редактирование
  Future<bool> updInstance(
    int gameId,
    GamesCompanion game,
    Set<int> designersIds,
    Set<int> artisrsIds,
    Set<int> tagsIds,
  ) async {
    return await transaction(() async {
      // 1. Обновляем
      final updateResult = await (update(games)..where((g) => g.id.equals(gameId))).write(game);
      
      // 2. Удаляем старые связи
      await (delete(gamesDesigners)..where((gd) => gd.gameId.equals(gameId))).go();
      await (delete(gamesArtists)..where((ga) => ga.gameId.equals(gameId))).go();
      await (delete(gamesTags)..where((gt) => gt.gameId.equals(gameId))).go();
      
      // 3. Добавляем новые связи
      for (final designerId in designersIds) {
        await into(gamesDesigners).insert(
          GamesDesignersCompanion(
            gameId: Value(gameId),
            designerId: Value(designerId),
          ),
        );
      }
      for (final artistId in artisrsIds) {
        await into(gamesArtists).insert(
          GamesArtistsCompanion(
            gameId: Value(gameId),
            artistId: Value(artistId),
          ),
        );
      }
      for (final tagId in tagsIds) {
        await into(gamesTags).insert(
          GamesTagsCompanion(
            gameId: Value(gameId),
            tagId: Value(tagId),
          ),
        );
      }
      
      return updateResult > 0;
    });
  }

  // Удаление
  Future<int> delInstance(int gameId) async {
    return await (delete(games)..where((g) => g.id.equals(gameId))).go();
  }

  // Все игры
  Future<List<Game>> getAll() async {
    return await select(games).get();
  }

  // Все базовые игры
  Future<List<Game>> getAllBase({int? excludeId}) async {
    var query = select(games)..where((g) => g.parentId.isNull());

    if (excludeId != null) {
      query = query..where((g) => g.id.isNotValue(excludeId));
    }
    
    return await query.get();
  }

  // Геймдизайнеры игры
  Future<List<Designer>> getGameDesigners(int gameId) async {
    final query = select(designers).join([
      innerJoin(gamesDesigners, gamesDesigners.designerId.equalsExp(designers.id)),
    ])..where(gamesDesigners.gameId.equals(gameId));
    
    final results = await query.get();

    return results.map((row) => row.readTable(designers)).toList();
  }

  // Художники игры
  Future<List<Artist>> getGameArtists(int gameId) async {
    final query = select(artists).join([
      innerJoin(gamesArtists, gamesArtists.artistId.equalsExp(artists.id)),
    ])..where(gamesArtists.gameId.equals(gameId));
    
    final results = await query.get();
    return results.map((row) => row.readTable(artists)).toList();
  }

  // Метки игры
  Future<List<Tag>> getGameTags(int gameId) async {
    final query = select(tags).join([
      innerJoin(gamesTags, gamesTags.tagId.equalsExp(tags.id)),
    ])..where(gamesTags.gameId.equals(gameId));
    
    final results = await query.get();
    return results.map((row) => row.readTable(tags)).toList();
  }  
  
  // Игра со всеми связанными сущностями
  Future<GameFullData?> getFullInfo(int gameId) async {
    final game = await (select(games)..where((g) => g.id.equals(gameId))).getSingleOrNull();

    if (game == null) return null;

    final Game? baseGame;

    baseGame =  (game.parentId != null) ? await (select(games)..where((g) => g.id.equals(game.parentId!))).getSingleOrNull() : null;
        
    final designers = await getGameDesigners(gameId);
    final selectedDesignerIds = designers.map((d) => d.id).toSet();

    final artists = await getGameArtists(gameId);
    final selectedArtistIds = artists.map((a) => a.id).toSet();

    final tags = await getGameTags(gameId);
    final selectedTagIds = tags.map((t) => t.id).toSet();

    return GameFullData(
      game: game,
      designers: designers,
      selectedDesignerIds: selectedDesignerIds,
      artists: artists,
      selectedArtistIds: selectedArtistIds,
      tags: tags,
      selectedTagIds: selectedTagIds,
      baseGame: baseGame,
    );
  }
}

