import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/export.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/services/image_service.dart';
part 'game_dao.g.dart';

@DriftAccessor(
  tables: [
    Games,
    ExpansionsGames,
    GamesDesigners,
    GamesArtists,
    GamesTags,
    GamesCountingTemplates,
    GamingSessions,
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
      ..where((g) => g.isStandalone.isValue(true) & g.id.isNotIn(gameIds));

    return await query.get();
  }

  // Все игры
  Future<List<Game>> getAll({
    bool onlyStandalone = false,
    int? artistId,
    int? designerId,
    int? tagId,
    Set<int>? ids,
  }) async {
    var query = _getBaseQuery();
    query = await _getFilteredQuery(
      query: query,
      onlyStandalone: onlyStandalone,
      artistId: artistId,
      designerId: designerId,
      tagId: tagId,
      ids: ids,
    );

    return await query.get();
  }

  // Только самодостаточные коробки
  Future<List<Game>> getStandalones() async {
    var query = _getBaseQuery();
    query = query..where((g) => g.isStandalone.isValue(true));
    return await query.get();
  }

  // Только по которым записаны партии
  Future<List<Game>> getAlreadyPlayed() async {
    final gamingSessionsQuery = selectOnly(gamingSessions, distinct: true)
      ..addColumns([gamingSessions.gameId]);
    final List<int> gamesPlayedIds = await gamingSessionsQuery
        .map((row) => row.read(gamingSessions.gameId)!)
        .get();

    var query = _getBaseQuery();
    query = query..where((g) => g.id.isIn(gamesPlayedIds));
    return await query.get();
  }

  // Игры с пагинацией
  Future<List<Game>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required bool onlyFavorite,
    required bool onlyStandalone,
    required bool isInCollection,
    required bool opportunitiesShelf,
    int? artistId,
    int? designerId,
    int? tagId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$GamesTable, Game> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = await _getFilteredQuery(
      query: query,
      onlyFavorite: onlyFavorite,
      onlyStandalone: onlyStandalone,
      isInCollection: isInCollection,
      opportunitiesShelf: opportunitiesShelf,
      artistId: artistId,
      designerId: designerId,
      tagId: tagId,
      searchQuery: searchQuery,
    );

    return await query.get();
  }

  // Общее количество игр, соответствующих условию
  Future<int> getTotalCount({
    bool onlyFavorite = false,
    bool onlyStandalone = false,
    bool isInCollection = false,
    bool opportunitiesShelf = false,
    int? artistId,
    int? designerId,
    int? tagId,
    String? searchQuery,
  }) async {
    SimpleSelectStatement<$GamesTable, Game> query = select(games);
    query = await _getFilteredQuery(
      query: query,
      onlyFavorite: onlyFavorite,
      artistId: artistId,
      designerId: designerId,
      tagId: tagId,
      onlyStandalone: onlyStandalone,
      isInCollection: isInCollection,
      opportunitiesShelf: opportunitiesShelf,
    );

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
        expression: g.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  Future<SimpleSelectStatement<$GamesTable, Game>> _getFilteredQuery({
    required SimpleSelectStatement<$GamesTable, Game> query,
    bool onlyFavorite = false,
    bool onlyStandalone = false,
    bool isInCollection = false,
    bool opportunitiesShelf = false,
    int? artistId,
    int? designerId,
    int? tagId,
    String? searchQuery,
    Set<int>? ids,
  }) async {
    if (onlyFavorite) {
      query = query..where((g) => g.isFavorite.isValue(true));
    }

    if (onlyStandalone) {
      query = query..where((g) => g.isStandalone.isValue(true));
    }

    if (isInCollection) {
      query = query..where((g) => g.isInCollection.isValue(true));
    }

    if (opportunitiesShelf) {
      final gamingSessionsQuery = selectOnly(gamingSessions, distinct: true)
        ..addColumns([gamingSessions.gameId]);
      final List<int> gamesPlayedIds = await gamingSessionsQuery
          .map((row) => row.read(gamingSessions.gameId)!)
          .get();

      query = query..where((g) => g.id.isNotIn(gamesPlayedIds));
    }

    if (artistId != null) {
      final artistsQuery = select(gamesArtists)
        ..where((ga) => ga.artistId.equals(artistId));
      final List<int> gamesIds = await artistsQuery
          .map((gamesArtist) => gamesArtist.gameId)
          .get();
      query = query..where((g) => g.id.isIn(gamesIds));
    } else if (designerId != null) {
      final designersQuery = select(gamesDesigners)
        ..where((gd) => gd.designerId.equals(designerId));
      final List<int> gamesIds = await designersQuery
          .map((gamesDesigner) => gamesDesigner.gameId)
          .get();
      query = query..where((g) => g.id.isIn(gamesIds));
    } else if (tagId != null) {
      final tagsQuery = select(gamesTags)
        ..where((gt) => gt.tagId.equals(tagId));
      final List<int> gamesIds = await tagsQuery
          .map((gamesTag) => gamesTag.gameId)
          .get();
      query = query..where((g) => g.id.isIn(gamesIds));
    }

    if (ids != null) {
      query = query..where((g) => g.id.isIn(ids));
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final regex = RegExp(r'^>=(\d+)$');

      final match = regex.firstMatch(searchQuery);
      if (match != null) {
        // group(0) — всё совпадение, group(1) — первая группа из (...)
        final int playersCount = int.parse(match.group(1)!);
        query = query
          ..where(
            (g) =>
                games.minPlayers.isSmallerOrEqualValue(playersCount) &
                games.maxPlayers.isBiggerOrEqualValue(playersCount),
          );
      } else {
        query = query
          ..where((g) {
            final lowerNameExpression = CustomExpression<String>(
              'lower_unicode(name)',
              watchedTables: [games],
            );

            return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
          });
      }
    }

    return query;
  }
}
