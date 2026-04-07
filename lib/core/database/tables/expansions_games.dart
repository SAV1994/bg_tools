import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';

// Junction table для связи Игровые сессии <-> Игры (дополнения)
class ExpansionsGames extends Table {
  @ReferenceName('expansions')
  IntColumn get expansionId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('bases')
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();

  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {expansionId, gameId};
}
