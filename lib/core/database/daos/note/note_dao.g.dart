// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_dao.dart';

// ignore_for_file: type=lint
mixin _$NoteDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $NotesTable get notes => attachedDatabase.notes;
  NoteDaoManager get managers => NoteDaoManager(this);
}

class NoteDaoManager {
  final _$NoteDaoMixin _db;
  NoteDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
}
