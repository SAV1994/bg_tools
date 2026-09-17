// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_type_dao.dart';

// ignore_for_file: type=lint
mixin _$ComponentTypeDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $ComponentTypesTable get componentTypes => attachedDatabase.componentTypes;
  $GameComponentsTable get gameComponents => attachedDatabase.gameComponents;
  ComponentTypeDaoManager get managers => ComponentTypeDaoManager(this);
}

class ComponentTypeDaoManager {
  final _$ComponentTypeDaoMixin _db;
  ComponentTypeDaoManager(this._db);
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
