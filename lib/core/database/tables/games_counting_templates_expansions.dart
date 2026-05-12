import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/games_counting_templates.dart';

// Junction table для связи (Игры <-> Шаблоны подсчёта) <-> Игры (дополнения)
class GamesCountingTemplatesExpansions extends Table {
  IntColumn get gamesCountingTemplateId => integer().references(
    GamesCountingTemplates,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();

  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gamesCountingTemplateId, gameId};
}
