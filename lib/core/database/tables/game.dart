import 'package:drift/drift.dart';

/// Таблица Игры
class Games extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  TextColumn get description => text().nullable()(); // Описание
  TextColumn get year => text().withLength(min: 1, max: 5).nullable()(); // Год
  IntColumn get minPlayers =>
      integer().nullable()(); // Минимальное количество игроков
  IntColumn get maxPlayers =>
      integer().nullable()(); // Максимальное количество игроков
  BoolColumn get isInCollection =>
      boolean().withDefault(const Constant(false))(); // Наличие в коллекции
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))(); // Помечена как любимая
  IntColumn get rating => integer().nullable()(); // Рейтинг
  BoolColumn get isStandalone =>
      boolean().withDefault(const Constant(true))(); // Самодостаточность игры
  TextColumn get imagePath => text().nullable()(); // Путь к изображению

  @override
  List<String> get customConstraints => ['UNIQUE (name)'];
}
