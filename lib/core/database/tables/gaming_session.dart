import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';

/// Таблица Игровые сессии
class GamingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  IntColumn get gameId => integer().references(Games, #id, onDelete: KeyAction.cascade)();  // Игра
  DateTimeColumn get startedAt => dateTime().nullable()();  // Время начала игры
  DateTimeColumn get finishedAt => dateTime().nullable()();  // Время окончания игры
}
