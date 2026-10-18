import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/designer.dart';
import 'package:bg_tools/core/database/tables/games_artists.dart';
import 'package:bg_tools/core/database/tables/games_designers.dart';
import 'package:bg_tools/core/database/tables/games_tags.dart';
import 'package:bg_tools/core/database/tables/rating.dart';
import 'package:bg_tools/core/dataclasses/export.dart';

part 'designer_dao.g.dart';

@DriftAccessor(
  tables: [Designers, Ratings, GamesArtists, GamesDesigners, GamesTags],
)
class DesignerDao extends DatabaseAccessor<AppDatabase>
    with _$DesignerDaoMixin {
  DesignerDao(super.db);

  // Создание новой записи
  Future<int> create(DesignersCompanion designer) async {
    return await into(designers).insert(designer);
  }

  // Редактирование
  Future<bool> updInstance(int designerId, DesignersCompanion designer) async {
    final updateResult = await (update(
      designers,
    )..where((d) => d.id.equals(designerId))).write(designer);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int designerId) async {
    return await (delete(
      designers,
    )..where((d) => d.id.equals(designerId))).go();
  }

  // Все геймдизайнеры
  Future<List<Designer>> getAll() async {
    SimpleSelectStatement<$DesignersTable, Designer> query = _getBaseQuery();
    return await query.get();
  }

  // Геймдизайнеры по которым есть топы
  Future<List<Designer>> getHasTop() async {
    final ratingsQuery = selectOnly(ratings, distinct: true)
      ..addColumns([ratings.designerId])
      ..where(ratings.designerId.isNotNull());
    final List<int> designersHasTop = await ratingsQuery
        .map((row) => row.read(ratings.designerId)!)
        .get();

    var query = _getBaseQuery();
    query = query..where((a) => a.id.isIn(designersHasTop));
    return await query.get();
  }

  // Геймдизайнеры игры которых есть
  Future<List<Designer>> getHasGames({Rating? rating}) async {
    var query = _getBaseQuery();

    var gamesDesignersQuery = selectOnly(gamesDesigners, distinct: true)
      ..addColumns([gamesDesigners.designerId]);

    if (rating != null) {
      final List<int> gamesIds = [];

      if (rating.artistId != null) {
        final gamesArtistsQuery = selectOnly(gamesArtists, distinct: true)
          ..addColumns([gamesArtists.gameId])
          ..where(gamesArtists.artistId.equals(rating.artistId!));
        gamesIds.addAll(
          await gamesArtistsQuery
              .map((row) => row.read(gamesArtists.gameId)!)
              .get(),
        );
      } else if (rating.designerId != null) {
        final gamesDesignersAdvQuery =
            selectOnly(gamesDesigners, distinct: true)
              ..addColumns([gamesDesigners.gameId])
              ..where(gamesDesigners.designerId.equals(rating.designerId!));
        gamesIds.addAll(
          await gamesDesignersAdvQuery
              .map((row) => row.read(gamesDesigners.gameId)!)
              .get(),
        );
      } else if (rating.tagId != null) {
        final gamesTagsQuery = selectOnly(gamesTags, distinct: true)
          ..addColumns([gamesTags.gameId])
          ..where(gamesTags.tagId.equals(rating.tagId!));
        gamesIds.addAll(
          await gamesTagsQuery.map((row) => row.read(gamesTags.gameId)!).get(),
        );
      }

      gamesDesignersQuery = gamesDesignersQuery
        ..where(gamesDesigners.gameId.isIn(gamesIds));
    }

    final List<int> designersHasGamesIds = await gamesDesignersQuery
        .map((row) => row.read(gamesDesigners.designerId)!)
        .get();

    query = query..where((a) => a.id.isIn(designersHasGamesIds));
    return await query.get();
  }

  // Геймдизайнеры с пагинацией
  Future<List<DesignertData>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$DesignersTable, Designer> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    final joinedQuery = query.join([
      rightOuterJoin(
        gamesDesigners,
        gamesDesigners.designerId.equalsExp(designers.id),
      ),
    ]);

    final rows = await joinedQuery.get();
    final Map<int, dynamic> designersMap = {};
    for (final row in rows) {
      final Designer designer = row.readTable(designers);
      final GamesDesigner? junction = row.readTable(gamesDesigners);

      if (designersMap[designer.id] != null) {
        designersMap[designer.id]['gamesCount'] += 1;
      } else {
        designersMap[designer.id] = {
          'designer': designer,
          'gamesCount': junction != null ? 1 : 0,
        };
      }
    }

    return designersMap.values
        .map(
          (artistData) => DesignertData(
            instance: artistData['designer'],
            gamesCount: artistData['gamesCount'],
          ),
        )
        .toList();
  }

  // Общее количество геймдизайнеров, соответствующих условию
  Future<int> getTotalCount({String? searchQuery}) async {
    SimpleSelectStatement<$DesignersTable, Designer> query = select(designers);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Геймдизайнер
  Future<Designer?> get(int designerId) async {
    return await (select(
      designers,
    )..where((d) => d.id.equals(designerId))).getSingleOrNull();
  }

  SimpleSelectStatement<$DesignersTable, Designer> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(designers)..orderBy([
      (d) => OrderingTerm(
        expression: d.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  SimpleSelectStatement<$DesignersTable, Designer> _getFilteredQuery({
    required SimpleSelectStatement<$DesignersTable, Designer> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((d) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [designers],
          );

          return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
        });
    }

    return query;
  }
}
