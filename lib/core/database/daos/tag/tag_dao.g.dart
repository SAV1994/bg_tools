// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dao.dart';

// ignore_for_file: type=lint
mixin _$TagDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $ArtistsTable get artists => attachedDatabase.artists;
  $DesignersTable get designers => attachedDatabase.designers;
  $RatingsTable get ratings => attachedDatabase.ratings;
  $GamesTable get games => attachedDatabase.games;
  $GamesTagsTable get gamesTags => attachedDatabase.gamesTags;
  TagDaoManager get managers => TagDaoManager(this);
}

class TagDaoManager {
  final _$TagDaoMixin _db;
  TagDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db.attachedDatabase, _db.ratings);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$GamesTagsTableTableManager get gamesTags =>
      $$GamesTagsTableTableManager(_db.attachedDatabase, _db.gamesTags);
}
