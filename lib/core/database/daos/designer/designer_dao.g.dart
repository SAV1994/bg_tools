// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_dao.dart';

// ignore_for_file: type=lint
mixin _$DesignerDaoMixin on DatabaseAccessor<AppDatabase> {
  $DesignersTable get designers => attachedDatabase.designers;
  $ArtistsTable get artists => attachedDatabase.artists;
  $TagsTable get tags => attachedDatabase.tags;
  $RatingsTable get ratings => attachedDatabase.ratings;
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
}
