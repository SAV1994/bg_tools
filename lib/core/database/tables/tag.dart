import 'package:drift/drift.dart';

/// Таблица Тэги
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  TextColumn get name => text().withLength(min: 1, max: 255)();  // Тэг

  @override
  List<String> get customConstraints => [
    'UNIQUE (name)',
  ];
}
