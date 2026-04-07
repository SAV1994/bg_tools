import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

// Junction table для связи Игры <-> Тэги 
class GamesTags extends Table {
  IntColumn get gameId => integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  
  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gameId, tagId};
}
