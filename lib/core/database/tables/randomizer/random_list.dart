import 'package:drift/drift.dart';

/// Таблица Рандомные списки
class RandomLists extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID
  TextColumn get name => text().withLength(min: 1, max: 255)(); // Название
  IntColumn get type => integer()(); // Тип (RandomListTypeEnum)
  BoolColumn get isUnique => boolean().withDefault(
    const Constant(true),
  )(); // Уникальность всех элементов списка
  IntColumn get itemsNum => integer()(); // Количество элементов в списке
}
