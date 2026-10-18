import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/features/top/consts.dart';

part 'rating_dao.g.dart';

@DriftAccessor(
  tables: [
    Ratings,
    RatingsGames,
    ExpansionsGames,
    GamesDesigners,
    GamesArtists,
    GamesTags,
    GamingSessions,
  ],
)
class RatingDao extends DatabaseAccessor<AppDatabase> with _$RatingDaoMixin {
  RatingDao(super.db);

  // Создать рейтинг
  Future<int> create(
    TopTypeEnum ratingType,
    RatingsCompanion rating,
    List<RatingGamePreSaveData> gamesData,
  ) async {
    switch (ratingType) {
      case TopTypeEnum.byTag:
        await (update(ratings)
              ..where((r) => r.tagId.equals(rating.tagId.value!)))
            .write(RatingsCompanion(isActual: Value(false)));
      case TopTypeEnum.byDesigner:
        await (update(ratings)
              ..where((r) => r.designerId.equals(rating.designerId.value!)))
            .write(RatingsCompanion(isActual: Value(false)));
      case TopTypeEnum.byArtist:
        await (update(ratings)
              ..where((r) => r.artistId.equals(rating.artistId.value!)))
            .write(RatingsCompanion(isActual: Value(false)));
      default:
        await (update(ratings)..where(
              (r) =>
                  r.tagId.isNull() &
                  r.designerId.isNull() &
                  r.artistId.isNull(),
            ))
            .write(RatingsCompanion(isActual: Value(false)));
    }

    int ratingId = await into(ratings).insert(rating);

    for (final gameData in gamesData) {
      await into(ratingsGames).insert(
        RatingsGamesCompanion(
          ratingId: Value(ratingId),
          gameId: Value(gameData.gameId),
          score: Value(gameData.score),
          place: Value(gameData.place),
        ),
      );
    }

    return ratingId;
  }

  // Удалить рейтинг
  Future<void> delInstance(int ratingId) async {
    await (delete(ratings)..where((r) => r.id.equals(ratingId))).go();
  }

  // Рейтинги с пагинацией
  Future<List<RatingData>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required TopTypeEnum ratingType,
    int? instanceId,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$RatingsTable, Rating> query = _getQuery(
      ratingType: ratingType,
      instanceId: instanceId,
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);

    late final List<RatingData> ratingData;
    switch (ratingType) {
      case TopTypeEnum.byTag:
        final joinedQuery = query.join([
          innerJoin(tags, tags.id.equalsExp(ratings.tagId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingData(
              rating: row.readTable(ratings),
              tag: row.readTable(tags),
            );
          }).toList(),
        );
      case TopTypeEnum.byDesigner:
        final joinedQuery = query.join([
          innerJoin(designers, designers.id.equalsExp(ratings.designerId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingData(
              rating: row.readTable(ratings),
              designer: row.readTable(designers),
            );
          }).toList(),
        );
      case TopTypeEnum.byArtist:
        final joinedQuery = query.join([
          innerJoin(artists, artists.id.equalsExp(ratings.artistId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingData(
              rating: row.readTable(ratings),
              artist: row.readTable(artists),
            );
          }).toList(),
        );
      default:
        ratingData = await query.get().then(
          (ratings) =>
              ratings.map((rating) => RatingData(rating: rating)).toList(),
        );
    }

    return ratingData;
  }

  // Общее количество рейтингов, соответствующих условию
  Future<int> getTotalCount({
    required TopTypeEnum ratingType,
    int? instanceId,
  }) async {
    SimpleSelectStatement<$RatingsTable, Rating> query = _getQuery(
      ratingType: ratingType,
      instanceId: instanceId,
    );

    return await query.get().then((list) => list.length);
  }

  // Игры рейтинга с пагинацией
  Future<List<RatingFullData>> getPaginatedGames({
    required TopTypeEnum ratingType,
    required int ratingId,
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    int? startYear,
    int? endYear,
    double? startRating,
    double? endRating,
    int? numPlayers,
    Set<int>? artistIds,
    Set<int>? designerIds,
    Set<int>? tagIds,
    bool? isPlayed,
    bool? isInCollection,
    bool? isFavorite,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    final query = select(ratings)..where((r) => r.id.equals(ratingId));
    final gamesQuery =
        await _getGamesQuery(
            ratingId: ratingId,
            reverse: reverseOrdering,
            startYear: startYear,
            endYear: endYear,
            startRating: startRating,
            endRating: endRating,
            numPlayers: numPlayers,
            isPlayed: isPlayed,
            isInCollection: isInCollection,
            isFavorite: isFavorite,
            artistIds: artistIds,
            designerIds: designerIds,
            tagIds: tagIds,
            searchQuery: searchQuery,
          )
          ..limit(pageSize, offset: offset);

    final List<RatingGameData> gamesData = await gamesQuery.get().then(
      (rows) => rows.map((row) {
        RatingsGame ratingGame = row.readTable(ratingsGames);
        return RatingGameData(
          game: row.readTable(games),
          score: ratingGame.score,
          place: ratingGame.place,
        );
      }).toList(),
    );

    late final List<RatingFullData> ratingData;
    switch (ratingType) {
      case TopTypeEnum.byTag:
        final joinedQuery = query.join([
          innerJoin(tags, tags.id.equalsExp(ratings.tagId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingFullData(
              rating: row.readTable(ratings),
              tag: row.readTable(tags),
              games: gamesData,
            );
          }).toList(),
        );
      case TopTypeEnum.byDesigner:
        final joinedQuery = query.join([
          innerJoin(designers, designers.id.equalsExp(ratings.designerId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingFullData(
              rating: row.readTable(ratings),
              designer: row.readTable(designers),
              games: gamesData,
            );
          }).toList(),
        );
      case TopTypeEnum.byArtist:
        final joinedQuery = query.join([
          innerJoin(artists, artists.id.equalsExp(ratings.artistId)),
        ]);
        ratingData = await joinedQuery.get().then(
          (rows) => rows.map((row) {
            return RatingFullData(
              rating: row.readTable(ratings),
              artist: row.readTable(artists),
              games: gamesData,
            );
          }).toList(),
        );
      default:
        ratingData = await query.get().then(
          (ratings) => ratings
              .map((rating) => RatingFullData(rating: rating, games: gamesData))
              .toList(),
        );
    }

    return ratingData;
  }

  // Общее количество игр рейтинга, соответствующих условию
  Future<int> getTotalGamesCount({
    required int ratingId,
    int? startYear,
    int? endYear,
    double? startRating,
    double? endRating,
    int? numPlayers,
    Set<int>? artistIds,
    Set<int>? designerIds,
    Set<int>? tagIds,
    bool? isPlayed,
    bool? isInCollection,
    bool? isFavorite,
    String? searchQuery,
  }) async {
    final query = await _getGamesQuery(
      ratingId: ratingId,
      startYear: startYear,
      endYear: endYear,
      startRating: startRating,
      endRating: endRating,
      numPlayers: numPlayers,
      isPlayed: isPlayed,
      isInCollection: isInCollection,
      isFavorite: isFavorite,
      artistIds: artistIds,
      designerIds: designerIds,
      tagIds: tagIds,
      searchQuery: searchQuery,
    );

    return await query.get().then((list) => list.length);
  }

  SimpleSelectStatement<$RatingsTable, Rating> _getQuery({
    required TopTypeEnum ratingType,
    int? instanceId,
    bool reverse = false,
  }) {
    SimpleSelectStatement<$RatingsTable, Rating> query = select(ratings)
      ..orderBy([
        (r) => OrderingTerm(
          expression: r.year,
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
        (r) => OrderingTerm(
          expression: r.month,
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
        (r) => OrderingTerm(
          expression: r.id,
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);

    switch (ratingType) {
      case TopTypeEnum.byTag:
        if (instanceId != null) {
          query = query..where((r) => r.tagId.equals(instanceId));
        } else {
          query = query..where((r) => r.tagId.isNotNull());
        }
      case TopTypeEnum.byDesigner:
        if (instanceId != null) {
          query = query..where((r) => r.designerId.equals(instanceId));
        } else {
          query = query..where((r) => r.designerId.isNotNull());
        }
      case TopTypeEnum.byArtist:
        if (instanceId != null) {
          query = query..where((r) => r.artistId.equals(instanceId));
        } else {
          query = query..where((r) => r.artistId.isNotNull());
        }
      default:
        query = query
          ..where(
            (r) =>
                r.tagId.isNull() & r.designerId.isNull() & r.artistId.isNull(),
          );
    }

    return query;
  }

  // Рейтинг
  Future<Rating?> getSingle(int ratingId) async {
    return await (select(
      ratings,
    )..where((r) => r.id.equals(ratingId))).getSingleOrNull();
  }

  Future<JoinedSelectStatement<HasResultSet, dynamic>> _getGamesQuery({
    required int ratingId,
    bool reverse = false,
    int? startYear,
    int? endYear,
    double? startRating,
    double? endRating,
    int? numPlayers,
    bool? isPlayed,
    bool? isInCollection,
    bool? isFavorite,
    Set<int>? artistIds,
    Set<int>? designerIds,
    Set<int>? tagIds,
    String? searchQuery,
  }) async {
    SimpleSelectStatement<$RatingsGamesTable, RatingsGame> query =
        select(ratingsGames)
          ..where((rt) => rt.ratingId.equals(ratingId))
          ..orderBy([
            (rg) => OrderingTerm(
              expression: rg.place,
              mode: reverse ? OrderingMode.desc : OrderingMode.asc,
            ),
          ]);
    var joinedQuery = query.join([
      innerJoin(games, games.id.equalsExp(ratingsGames.gameId)),
    ]);

    if (startYear != null) {
      joinedQuery.where(games.year.isBiggerOrEqualValue(startYear.toString()));
    }

    if (endYear != null) {
      joinedQuery.where(games.year.isSmallerOrEqualValue(endYear.toString()));
    }

    if (startRating != null) {
      joinedQuery.where(
        games.rating.isBiggerOrEqualValue(roundDouble(startRating, 1)),
      );
    }

    if (endRating != null) {
      joinedQuery.where(
        games.rating.isSmallerOrEqualValue(roundDouble(endRating, 1)),
      );
    }

    if (numPlayers != null) {
      joinedQuery.where(
        games.minPlayers.isSmallerOrEqualValue(numPlayers) &
            games.maxPlayers.isBiggerOrEqualValue(numPlayers),
      );
    }

    if (isPlayed != null) {
      final gamingSessionsQuery = selectOnly(gamingSessions, distinct: true)
        ..addColumns([gamingSessions.gameId]);
      final List<int> gamesPlayedIds = await gamingSessionsQuery
          .map((row) => row.read(gamingSessions.gameId)!)
          .get();
      if (isPlayed) {
        joinedQuery.where(games.id.isIn(gamesPlayedIds));
      } else {
        joinedQuery.where(games.id.isNotIn(gamesPlayedIds));
      }
    }

    if (isInCollection != null) {
      joinedQuery.where(games.isInCollection.isValue(isInCollection));
    }

    if (isFavorite != null) {
      joinedQuery.where(games.isFavorite.isValue(isFavorite));
    }

    if (artistIds != null && artistIds.isNotEmpty) {
      final artistsQuery = select(gamesArtists)
        ..where((ga) => ga.artistId.isIn(artistIds));
      final List<int> gamesIds = await artistsQuery
          .map((gamesArtist) => gamesArtist.gameId)
          .get();
      joinedQuery.where(games.id.isIn(gamesIds));
    }

    if (designerIds != null && designerIds.isNotEmpty) {
      final designersQuery = select(gamesDesigners)
        ..where((gd) => gd.designerId.isIn(designerIds));
      final List<int> gamesIds = await designersQuery
          .map((gamesDesigner) => gamesDesigner.gameId)
          .get();
      joinedQuery.where(games.id.isIn(gamesIds));
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      final tagsQuery = select(gamesTags)..where((gt) => gt.tagId.isIn(tagIds));
      final List<int> gamesIds = await tagsQuery
          .map((gamesTag) => gamesTag.gameId)
          .get();
      joinedQuery.where(games.id.isIn(gamesIds));
    }

    if (searchQuery != null) {
      final searchCondition = CustomExpression<bool>(
        'lower_unicode(games.name) LIKE \'%${searchQuery.toLowerCase()}%\'',
        watchedTables: [games],
      );

      joinedQuery = joinedQuery..where(searchCondition);
    }

    return joinedQuery;
  }
}
