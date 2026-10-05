// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_setup_dao.dart';

// ignore_for_file: type=lint
mixin _$SavedSetupDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $RandomSetupsTable get randomSetups => attachedDatabase.randomSetups;
  $SavedSetupsTable get savedSetups => attachedDatabase.savedSetups;
  $RandomListsTable get randomLists => attachedDatabase.randomLists;
  $ComponentTypesTable get componentTypes => attachedDatabase.componentTypes;
  $GameComponentsTable get gameComponents => attachedDatabase.gameComponents;
  $ListItemsTable get listItems => attachedDatabase.listItems;
  $SavedSetupsListsItemsTable get savedSetupsListsItems =>
      attachedDatabase.savedSetupsListsItems;
  SavedSetupDaoManager get managers => SavedSetupDaoManager(this);
}

class SavedSetupDaoManager {
  final _$SavedSetupDaoMixin _db;
  SavedSetupDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$RandomSetupsTableTableManager get randomSetups =>
      $$RandomSetupsTableTableManager(_db.attachedDatabase, _db.randomSetups);
  $$SavedSetupsTableTableManager get savedSetups =>
      $$SavedSetupsTableTableManager(_db.attachedDatabase, _db.savedSetups);
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
  $$SavedSetupsListsItemsTableTableManager get savedSetupsListsItems =>
      $$SavedSetupsListsItemsTableTableManager(
        _db.attachedDatabase,
        _db.savedSetupsListsItems,
      );
}
