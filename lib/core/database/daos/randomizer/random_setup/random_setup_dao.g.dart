// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_setup_dao.dart';

// ignore_for_file: type=lint
mixin _$RandomSetupDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $RandomSetupsTable get randomSetups => attachedDatabase.randomSetups;
  $RandomListsTable get randomLists => attachedDatabase.randomLists;
  $ComponentTypesTable get componentTypes => attachedDatabase.componentTypes;
  $GameComponentsTable get gameComponents => attachedDatabase.gameComponents;
  $ListItemsTable get listItems => attachedDatabase.listItems;
  RandomSetupDaoManager get managers => RandomSetupDaoManager(this);
}

class RandomSetupDaoManager {
  final _$RandomSetupDaoMixin _db;
  RandomSetupDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$RandomSetupsTableTableManager get randomSetups =>
      $$RandomSetupsTableTableManager(_db.attachedDatabase, _db.randomSetups);
  $$RandomListsTableTableManager get randomLists =>
      $$RandomListsTableTableManager(_db.attachedDatabase, _db.randomLists);
  $$ComponentTypesTableTableManager get componentTypes =>
      $$ComponentTypesTableTableManager(
        _db.attachedDatabase,
        _db.componentTypes,
      );
  $$GameComponentsTableTableManager get gameComponents =>
      $$GameComponentsTableTableManager(
        _db.attachedDatabase,
        _db.gameComponents,
      );
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db.attachedDatabase, _db.listItems);
}
