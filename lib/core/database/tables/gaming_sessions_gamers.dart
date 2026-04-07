import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/gamer.dart';
import 'package:bg_tools/core/database/tables/gaming_session.dart';

// Junction table для связи Игровые сессии <-> Игроки 
class GamingSessionsGamers extends Table {
  IntColumn get gamingSessionId => integer().references(GamingSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get gamerId => integer().references(Gamers, #id, onDelete: KeyAction.cascade)();
  IntColumn get score => integer().nullable()();  // Количкство набранных очков
  IntColumn get place => integer().nullable()();  // Занятое место
  
  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gamingSessionId, gamerId};
}
