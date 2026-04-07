// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamer_dao.dart';

// ignore_for_file: type=lint
mixin _$GamerDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamersTable get gamers => attachedDatabase.gamers;
  GamerDaoManager get managers => GamerDaoManager(this);
}

class GamerDaoManager {
  final _$GamerDaoMixin _db;
  GamerDaoManager(this._db);
  $$GamersTableTableManager get gamers =>
      $$GamersTableTableManager(_db.attachedDatabase, _db.gamers);
}
