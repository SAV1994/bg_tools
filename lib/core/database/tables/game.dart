import 'package:drift/drift.dart';

/// Таблица Игры
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  TextColumn get title => text().withLength(min: 1, max: 255)();  // Название
  TextColumn get description => text().nullable()();  // Описание
  TextColumn get year => text().withLength(min: 1, max: 5).nullable()(); // Год
  IntColumn get minPlayers => integer().nullable()();  // Минимальное количество игроков
  IntColumn get maxPlayers => integer().nullable()();  // Максимальное количество игроков
  IntColumn get parentId => integer().nullable().references(Games, #id, onDelete: KeyAction.setNull)();  // Базовая игра
  BoolColumn get isInCollection => boolean().withDefault(const Constant(false))();  // Наличие в коллекции

  @override
  List<String> get customConstraints => [
    'UNIQUE (title)',
  ];
}
