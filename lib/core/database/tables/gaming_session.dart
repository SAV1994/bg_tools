import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';

/// Таблица Игровые сессии
class GamingSessions extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)(); // Игра
  DateTimeColumn get startedAt => dateTime()(); // Время начала игры
  DateTimeColumn get finishedAt =>
      dateTime().nullable()(); // Время окончания игры
  TextColumn get comment => text().nullable()(); // Комментарий
  IntColumn get gameType => integer().nullable()(); // Тип игры
  TextColumn get data => text().nullable()(); // Данные (JSON)
  IntColumn get rootSessionId =>
      integer().nullable().references(GamingSessions, #id)();
}
