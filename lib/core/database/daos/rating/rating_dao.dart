import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/features/top/consts.dart';

part 'rating_dao.g.dart';

@DriftAccessor(tables: [Ratings, RatingsGames])
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
    await (delete(
      ratingsGames,
    )..where((rg) => rg.ratingId.equals(ratingId))).go();
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
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    final query = select(ratings)..where((r) => r.id.equals(ratingId));
    final gamesQuery = _getGamesQuery(
      ratingId: ratingId,
      reverse: reverseOrdering,
      searchQuery: searchQuery,
    )..limit(pageSize, offset: offset);

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
    String? searchQuery,
  }) async {
    final query = _getGamesQuery(ratingId: ratingId, searchQuery: searchQuery);

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

  JoinedSelectStatement<HasResultSet, dynamic> _getGamesQuery({
    required int ratingId,
    bool reverse = false,
    String? searchQuery,
  }) {
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
