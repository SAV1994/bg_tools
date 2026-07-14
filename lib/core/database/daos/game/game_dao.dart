import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/expansions_games.dart';
import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/games_artists.dart';
import 'package:bg_tools/core/database/tables/games_counting_templates.dart';
import 'package:bg_tools/core/database/tables/games_designers.dart';
import 'package:bg_tools/core/database/tables/games_tags.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/services/image_service.dart';
import 'package:drift/drift.dart';

part 'game_dao.g.dart';

@DriftAccessor(
  tables: [
    Games,
    ExpansionsGames,
    GamesDesigners,
    GamesArtists,
    GamesTags,
    GamesCountingTemplates,
  ],
)
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  // Создание новой записи
  Future<int> create(
    GamesCompanion game,
    Set<int> baseIds,
    Set<int> designerIds,
    Set<int> artisrIds,
    Set<int> tagIds,
  ) async {
    final int gameId = await into(games).insert(game);

    for (final baseId in baseIds) {
      await into(expansionsGames).insert(
        ExpansionsGamesCompanion(
          gameId: Value(baseId),
          expansionId: Value(gameId),
        ),
      );
    }

    for (final designerId in designerIds) {
      await into(gamesDesigners).insert(
        GamesDesignersCompanion(
          gameId: Value(gameId),
          designerId: Value(designerId),
        ),
      );
    }

    for (final artistId in artisrIds) {
      await into(gamesArtists).insert(
        GamesArtistsCompanion(gameId: Value(gameId), artistId: Value(artistId)),
      );
    }

    for (final tagId in tagIds) {
      await into(
        gamesTags,
      ).insert(GamesTagsCompanion(gameId: Value(gameId), tagId: Value(tagId)));
    }

    return gameId;
  }

  // Редактирование
  Future<bool> updInstance(
    int gameId,
    GamesCompanion game,
    Set<int> baseIds,
    Set<int> designersIds,
    Set<int> artisrsIds,
    Set<int> tagsIds,
  ) async {
    return await transaction(() async {
      // 1. Обновляем
      final updateResult = await (update(
        games,
      )..where((g) => g.id.equals(gameId))).write(game);

      // 2. Удаляем старые связи
      await (delete(
        expansionsGames,
      )..where((eg) => eg.expansionId.equals(gameId))).go();
      await (delete(
        gamesDesigners,
      )..where((gd) => gd.gameId.equals(gameId))).go();
      await (delete(
        gamesArtists,
      )..where((ga) => ga.gameId.equals(gameId))).go();
      await (delete(gamesTags)..where((gt) => gt.gameId.equals(gameId))).go();

      // 3. Добавляем новые связи
      for (final baseId in baseIds) {
        await into(expansionsGames).insert(
          ExpansionsGamesCompanion(
            gameId: Value(baseId),
            expansionId: Value(gameId),
          ),
        );
      }
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
          GamesTagsCompanion(gameId: Value(gameId), tagId: Value(tagId)),
        );
      }

      return updateResult > 0;
    });
  }

  Future<bool> updateIsFavorite(int gameId, bool value) async {
    final result = await (update(games)..where((g) => g.id.equals(gameId)))
        .write(GamesCompanion(isFavorite: Value(value)));

    return result > 0;
  }

  // Удаление
  Future<int> delInstance(int gameId) async {
    final game = await getSingle(gameId);
    if (game != null && game.imagePath != null) {
      await ImageService.deleteImage(game.imagePath);
    }
    return await (delete(games)..where((g) => g.id.equals(gameId))).go();
  }

  // Все игры кроме текущей
  Future<List<Game>> getAllExceptSelected(List<int> gameIds) async {
    var query = _getBaseQuery();
    query = query
      ..where((g) => g.isStandalone.isValue(true) & g.id.isIn(gameIds).not());
    return await query.get();
  }

  // Все игры
  Future<List<Game>> getAll() async {
    final query = _getBaseQuery();
    return await query.get();
  }

  // Только самодостаточные коробки
  Future<List<Game>> getStandalones() async {
    var query = _getBaseQuery();
    query = query..where((g) => g.isStandalone.isValue(true));
    return await query.get();
  }

  // Все игры (поток)
  Stream<List<Game>> watchAll() {
    final query = _getBaseQuery();
    return query.watch();
  }

  // Получить игры с пагинацией
  Future<List<Game>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required bool onlyFavorite,
    required bool onlyStandalone,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    var query = _getBaseQuery(reverse: reverseOrdering)
      ..limit(pageSize, offset: offset);

    if (onlyFavorite) {
      query = query..where((g) => g.isFavorite.isValue(true));
    }

    if (onlyStandalone) {
      query = query..where((g) => g.isStandalone.isValue(true));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query..where((g) => g.name.contains(searchQuery));
    }

    return await query.get();
  }

  // Общее количество игр, соответствующих условию
  Future<int> getTotalCount({String? searchQuery}) async {
    var query = select(games);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query..where((g) => g.name.contains(searchQuery));
    }

    return await query.get().then((list) => list.length);
  }

  // Базовые игры
  Future<List<Game>> getBases(int gameId) async {
    final query = select(games).join([
      innerJoin(expansionsGames, expansionsGames.gameId.equalsExp(games.id)),
    ])..where(expansionsGames.expansionId.equals(gameId));

    final results = await query.get();

    return results.map((row) => row.readTable(games)).toList();
  }

  // Дополнения
  Future<List<Game>> getExpansions(int gameId) async {
    final query = select(games).join([
      innerJoin(
        expansionsGames,
        expansionsGames.expansionId.equalsExp(games.id),
      ),
    ])..where(expansionsGames.gameId.equals(gameId));

    final results = await query.get();

    return results.map((row) => row.readTable(games)).toList();
  }

  // Геймдизайнеры игры
  Future<List<Designer>> getGameDesigners(int gameId) async {
    final query = select(designers).join([
      innerJoin(
        gamesDesigners,
        gamesDesigners.designerId.equalsExp(designers.id),
      ),
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

  // Количество шаблонов
  Future<int> getTemplatesCount(int gameId) async {
    final query = select(gamesCountingTemplates)
      ..where((gct) => gct.gameId.equals(gameId));
    final templates = await query.get();

    return templates.length;
  }

  // Игра со всеми связанными сущностями
  Future<GameFullData?> getFullInfo(int gameId) async {
    final game = await (select(
      games,
    )..where((g) => g.id.equals(gameId))).getSingleOrNull();

    if (game == null) return null;

    final designers = await getGameDesigners(gameId);
    final selectedDesignerIds = designers.map((d) => d.id).toSet();

    final artists = await getGameArtists(gameId);
    final selectedArtistIds = artists.map((a) => a.id).toSet();

    final tags = await getGameTags(gameId);
    final selectedTagIds = tags.map((t) => t.id).toSet();

    final bases = await getBases(gameId);
    final selectedBaseIds = bases.map((g) => g.id).toSet();

    final expansions = await getExpansions(gameId);

    final int templatesCount = await getTemplatesCount(gameId);

    return GameFullData(
      game: game,
      bases: bases,
      selectedBaseIds: selectedBaseIds,
      designers: designers,
      selectedDesignerIds: selectedDesignerIds,
      artists: artists,
      selectedArtistIds: selectedArtistIds,
      tags: tags,
      selectedTagIds: selectedTagIds,
      expansions: expansions,
      templatesCount: templatesCount,
    );
  }

  // Игра
  Future<Game?> getSingle(int gameId) async {
    return (select(games)..where((g) => g.id.equals(gameId))).getSingleOrNull();
  }

  SimpleSelectStatement<$GamesTable, Game> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(games)..orderBy([
      (g) => OrderingTerm(
        expression: g.name,
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }
}
