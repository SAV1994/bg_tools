import 'package:drift/drift.dart';

/// Таблица Художники
class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();  // ID
  TextColumn get name => text().withLength(min: 1, max: 255)();  // Художник

  @override
  List<String> get customConstraints => [
    'UNIQUE (name)',
  ];
}
