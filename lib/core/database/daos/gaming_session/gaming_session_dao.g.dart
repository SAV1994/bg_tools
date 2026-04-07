// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_session_dao.dart';

// ignore_for_file: type=lint
mixin _$GamingSessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $GamingSessionsTable get gamingSessions => attachedDatabase.gamingSessions;
  $GamersTable get gamers => attachedDatabase.gamers;
  $GamingSessionsGamersTable get gamingSessionsGamers =>
      attachedDatabase.gamingSessionsGamers;
  GamingSessionDaoManager get managers => GamingSessionDaoManager(this);
}

class GamingSessionDaoManager {
  final _$GamingSessionDaoMixin _db;
  GamingSessionDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$GamingSessionsTableTableManager get gamingSessions =>
      $$GamingSessionsTableTableManager(
        _db.attachedDatabase,
        _db.gamingSessions,
      );
  $$GamersTableTableManager get gamers =>
      $$GamersTableTableManager(_db.attachedDatabase, _db.gamers);
  $$GamingSessionsGamersTableTableManager get gamingSessionsGamers =>
      $$GamingSessionsGamersTableTableManager(
        _db.attachedDatabase,
        _db.gamingSessionsGamers,
      );
}
