// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_dao.dart';

// ignore_for_file: type=lint
mixin _$DesignerDaoMixin on DatabaseAccessor<AppDatabase> {
  $DesignersTable get designers => attachedDatabase.designers;
  DesignerDaoManager get managers => DesignerDaoManager(this);
}

class DesignerDaoManager {
  final _$DesignerDaoMixin _db;
  DesignerDaoManager(this._db);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db.attachedDatabase, _db.designers);
}
