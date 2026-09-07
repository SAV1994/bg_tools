// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_list_dao.dart';

// ignore_for_file: type=lint
mixin _$RandomListDaoMixin on DatabaseAccessor<AppDatabase> {
  $RandomListsTable get randomLists => attachedDatabase.randomLists;
  $ListItemsTable get listItems => attachedDatabase.listItems;
  RandomListDaoManager get managers => RandomListDaoManager(this);
}

class RandomListDaoManager {
  final _$RandomListDaoMixin _db;
  RandomListDaoManager(this._db);
  $$RandomListsTableTableManager get randomLists =>
      $$RandomListsTableTableManager(_db.attachedDatabase, _db.randomLists);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db.attachedDatabase, _db.listItems);
}
