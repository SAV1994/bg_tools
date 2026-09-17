import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/tables/randomizer/component_type.dart';

/// Таблица Компонентов
class GameComponents extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get componentTypeId =>
      integer().references(ComponentTypes, #id, onDelete: KeyAction.cascade)();
  TextColumn get imagePath => text().nullable()(); // Путь к изображению

  @override
  List<Set<Column>> get uniqueKeys => [
    {name, componentTypeId},
  ];
}
