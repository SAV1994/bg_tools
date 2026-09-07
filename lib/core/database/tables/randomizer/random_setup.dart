import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';

/// Таблица Рандомные сетапы
class RandomSetups extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)(); // Игра

  // Составной первичный ключ, чтобы избежать дублирования
  Set<Column> get unique => {name, gameId};
}
