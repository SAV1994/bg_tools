// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dao.dart';

// ignore_for_file: type=lint
mixin _$GameDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $DesignersTable get designers => attachedDatabase.designers;
  $GamesDesignersTable get gamesDesigners => attachedDatabase.gamesDesigners;
  $ArtistsTable get artists => attachedDatabase.artists;
  $GamesArtistsTable get gamesArtists => attachedDatabase.gamesArtists;
  $TagsTable get tags => attachedDatabase.tags;
  $GamesTagsTable get gamesTags => attachedDatabase.gamesTags;
  GameDaoManager get managers => GameDaoManager(this);
}

class GameDaoManager {
  final _$GameDaoMixin _db;
  GameDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
  $$GamesDesignersTableTableManager get gamesDesigners =>
      $$GamesDesignersTableTableManager(
        _db.attachedDatabase,
        _db.gamesDesigners,
      );
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
  $$GamesArtistsTableTableManager get gamesArtists =>
      $$GamesArtistsTableTableManager(_db.attachedDatabase, _db.gamesArtists);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$GamesTagsTableTableManager get gamesTags =>
      $$GamesTagsTableTableManager(_db.attachedDatabase, _db.gamesTags);
}
