import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/artist.dart';
import 'package:bg_tools/core/database/tables/game.dart';

// Junction table для связи Игры <-> Художники 
class GamesArtists extends Table {
  IntColumn get gameId => integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get artistId => integer().references(Artists, #id, onDelete: KeyAction.cascade)();
  
  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {gameId, artistId};
}
