// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_dao.dart';

// ignore_for_file: type=lint
mixin _$ArtistDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistsTable get artists => attachedDatabase.artists;
  ArtistDaoManager get managers => ArtistDaoManager(this);
}

class ArtistDaoManager {
  final _$ArtistDaoMixin _db;
  ArtistDaoManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
}
