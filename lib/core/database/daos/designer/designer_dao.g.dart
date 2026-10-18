// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_dao.dart';

// ignore_for_file: type=lint
mixin _$DesignerDaoMixin on DatabaseAccessor<AppDatabase> {
  $DesignersTable get designers => attachedDatabase.designers;
  $ArtistsTable get artists => attachedDatabase.artists;
  $TagsTable get tags => attachedDatabase.tags;
  $RatingsTable get ratings => attachedDatabase.ratings;
  $GamesTable get games => attachedDatabase.games;
  $GamesArtistsTable get gamesArtists => attachedDatabase.gamesArtists;
  $GamesDesignersTable get gamesDesigners => attachedDatabase.gamesDesigners;
  $GamesTagsTable get gamesTags => attachedDatabase.gamesTags;
  DesignerDaoManager get managers => DesignerDaoManager(this);
}

class DesignerDaoManager {
  final _$DesignerDaoMixin _db;
  DesignerDaoManager(this._db);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db.attachedDatabase, _db.ratings);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$GamesArtistsTableTableManager get gamesArtists =>
      $$GamesArtistsTableTableManager(_db.attachedDatabase, _db.gamesArtists);
  $$GamesDesignersTableTableManager get gamesDesigners =>
      $$GamesDesignersTableTableManager(
        _db.attachedDatabase,
        _db.gamesDesigners,
      );
  $$GamesTagsTableTableManager get gamesTags =>
      $$GamesTagsTableTableManager(_db.attachedDatabase, _db.gamesTags);
}
