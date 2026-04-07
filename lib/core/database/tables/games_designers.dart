import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/designer.dart';
import 'package:bg_tools/core/database/tables/game.dart';

// Junction table для связи Игры <-> Тэги 
class GamesDesigners extends Table {
  IntColumn get gameId => integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get designerId => integer().references(Designers, #id, onDelete: KeyAction.cascade)();
  
  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gameId, designerId};
}
