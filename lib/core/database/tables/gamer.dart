import 'package:drift/drift.dart';

/// Таблица Игроки
class Gamers extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  TextColumn get username => text().withLength(min: 1, max: 20)();  // Ник
  TextColumn get firstName => text().withLength(min: 1, max: 20).nullable()();  // Имя
  TextColumn get lastName => text().withLength(min: 1, max: 20).nullable()();  // Фамилия
  TextColumn get middleName => text().withLength(min: 1, max: 20).nullable()();  // Отчество
  BoolColumn get isOwner => boolean().withDefault(const Constant(false))(); // Владелец?

  @override
  List<String> get customConstraints => [
    'UNIQUE (username)',
  ];
}
