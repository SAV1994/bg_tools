import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/game.dart';

/// Таблица Заметки
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)(); // Игра
  TextColumn get title => text().withLength(min: 1, max: 255)(); // Название
  TextColumn get content => text()
      .nullable()(); // Форматированный текст из fleather (хранится в формате Delta JSON)
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)(); // Время создания
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)(); // Время обновления
}
