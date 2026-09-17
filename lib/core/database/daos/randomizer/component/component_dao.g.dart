// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_dao.dart';

// ignore_for_file: type=lint
mixin _$ComponentDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $ComponentTypesTable get componentTypes => attachedDatabase.componentTypes;
  $GameComponentsTable get gameComponents => attachedDatabase.gameComponents;
  ComponentDaoManager get managers => ComponentDaoManager(this);
}

class ComponentDaoManager {
  final _$ComponentDaoMixin _db;
  ComponentDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
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
}
