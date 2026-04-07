import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/gaming_session.dart';

// Junction table для связи Игровые сессии <-> Игры (дополнения)
class GamingSessionsExpansions extends Table {
  IntColumn get gamingSessionId =>
      integer().references(GamingSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();

  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gamingSessionId, gameId};
}
