import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/artist.dart';
import 'package:bg_tools/core/database/tables/rating.dart';

part 'artist_dao.g.dart';

@DriftAccessor(tables: [Artists, Ratings])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  ArtistDao(super.db);

  // Создание новой записи
  Future<int> create(ArtistsCompanion artist) async {
    return await into(artists).insert(artist);
  }

  // Редактирование
  Future<bool> updInstance(int artistId, ArtistsCompanion artist) async {
    final updateResult = await (update(
      artists,
    )..where((a) => a.id.equals(artistId))).write(artist);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int artistId) async {
    return await (delete(artists)..where((a) => a.id.equals(artistId))).go();
  }

  // Все художники
  Future<List<Artist>> getAll() async {
    SimpleSelectStatement<$ArtistsTable, Artist> query = _getBaseQuery();
    return await query.get();
  }

  // Художники по которым есть топы
  Future<List<Artist>> getHasTop() async {
    final ratingsQuery = selectOnly(ratings, distinct: true)
      ..addColumns([ratings.artistId])
      ..where(ratings.artistId.isNotNull());
    final List<int> artistsHasTop = await ratingsQuery
        .map((row) => row.read(ratings.artistId)!)
        .get();

    var query = _getBaseQuery();
    query = query..where((a) => a.id.isIn(artistsHasTop));
    return await query.get();
  }

  // Художники с пагинацией
  Future<List<Artist>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$ArtistsTable, Artist> query = _getBaseQuery(
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get();
  }

  // Общее количество художников, соответствующих условию
  Future<int> getTotalCount({String? searchQuery}) async {
    SimpleSelectStatement<$ArtistsTable, Artist> query = select(artists);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Художник
  Future<Artist?> get(int artistId) async {
    return await (select(
      artists,
    )..where((a) => a.id.equals(artistId))).getSingleOrNull();
  }

  SimpleSelectStatement<$ArtistsTable, Artist> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(artists)..orderBy([
      (a) => OrderingTerm(
        expression: a.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }

  SimpleSelectStatement<$ArtistsTable, Artist> _getFilteredQuery({
    required SimpleSelectStatement<$ArtistsTable, Artist> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((a) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(name)',
            watchedTables: [artists],
          );

          return lowerNameExpression.like('%${searchQuery.toLowerCase()}%');
        });
    }

    return query;
  }
}
