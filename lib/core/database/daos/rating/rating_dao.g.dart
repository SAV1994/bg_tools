// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_dao.dart';

// ignore_for_file: type=lint
mixin _$RatingDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistsTable get artists => attachedDatabase.artists;
  $DesignersTable get designers => attachedDatabase.designers;
  $TagsTable get tags => attachedDatabase.tags;
  $RatingsTable get ratings => attachedDatabase.ratings;
  $GamesTable get games => attachedDatabase.games;
  $RatingsGamesTable get ratingsGames => attachedDatabase.ratingsGames;
  RatingDaoManager get managers => RatingDaoManager(this);
}

class RatingDaoManager {
  final _$RatingDaoMixin _db;
  RatingDaoManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db.attachedDatabase, _db.ratings);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$RatingsGamesTableTableManager get ratingsGames =>
      $$RatingsGamesTableTableManager(_db.attachedDatabase, _db.ratingsGames);
}
