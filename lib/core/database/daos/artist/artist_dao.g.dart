// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_dao.dart';

// ignore_for_file: type=lint
mixin _$ArtistDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistsTable get artists => attachedDatabase.artists;
  $DesignersTable get designers => attachedDatabase.designers;
  $TagsTable get tags => attachedDatabase.tags;
  $RatingsTable get ratings => attachedDatabase.ratings;
  ArtistDaoManager get managers => ArtistDaoManager(this);
}

class ArtistDaoManager {
  final _$ArtistDaoMixin _db;
  ArtistDaoManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db.attachedDatabase, _db.ratings);
}
