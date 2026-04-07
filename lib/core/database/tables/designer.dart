import 'package:drift/drift.dart';

/// Таблица Геймдизайнеры
class Designers extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  TextColumn get name => text().withLength(min: 1, max: 255)();  // Дизайнер

  @override
  List<String> get customConstraints => [
    'UNIQUE (name)',
  ];
}
