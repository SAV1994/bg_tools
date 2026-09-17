import 'package:bg_tools/core/database/tables/game.dart';
import 'package:drift/drift.dart';

/// Таблица Типы компонентов
class ComponentTypes extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)(); // Игра

  @override
  List<Set<Column>> get uniqueKeys => [
    {name, gameId},
  ];
}
