import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/rating.dart';

// Junction table для связи Игры <-> ТОПы настольный игр
class RatingsGames extends Table {
  IntColumn get ratingId =>
      integer().references(Ratings, #id, onDelete: KeyAction.cascade)();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  RealColumn get score => real().nullable()(); // Количество набранных очков
  IntColumn get place => integer().nullable()(); // Занятое место

  // Составной первичный ключ, чтобы избежать дублирования
  @override
  Set<Column> get primaryKey => {ratingId, gameId};
}
