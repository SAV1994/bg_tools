// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_counting_templates_dao.dart';

// ignore_for_file: type=lint
mixin _$GamesCountingTemplatesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $CountingTemplatesTable get countingTemplates =>
      attachedDatabase.countingTemplates;
  $GamesCountingTemplatesTable get gamesCountingTemplates =>
      attachedDatabase.gamesCountingTemplates;
  $GamesCountingTemplatesExpansionsTable get gamesCountingTemplatesExpansions =>
      attachedDatabase.gamesCountingTemplatesExpansions;
  GamesCountingTemplatesDaoManager get managers =>
      GamesCountingTemplatesDaoManager(this);
}

class GamesCountingTemplatesDaoManager {
  final _$GamesCountingTemplatesDaoMixin _db;
  GamesCountingTemplatesDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$CountingTemplatesTableTableManager get countingTemplates =>
      $$CountingTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.countingTemplates,
      );
  $$GamesCountingTemplatesTableTableManager get gamesCountingTemplates =>
      $$GamesCountingTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.gamesCountingTemplates,
      );
  $$GamesCountingTemplatesExpansionsTableTableManager
  get gamesCountingTemplatesExpansions =>
      $$GamesCountingTemplatesExpansionsTableTableManager(
        _db.attachedDatabase,
        _db.gamesCountingTemplatesExpansions,
      );
}
