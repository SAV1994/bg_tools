import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/designer.dart';

part 'designer_dao.g.dart';

@DriftAccessor(tables: [Designers])
class DesignerDao extends DatabaseAccessor<AppDatabase> with _$DesignerDaoMixin {
  DesignerDao(super.db);
  
  // Создание новой записи
  Future<int> create(DesignersCompanion designer) async {
    return await into(designers).insert(designer);
  }

  // Редактирование
  Future<bool> updInstance(int designerId, DesignersCompanion designer) async {
    final updateResult = await (update(designers)..where((d) => d.id.equals(designerId))).write(designer);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int designerId) async {
    return await (delete(designers)..where((d) => d.id.equals(designerId))).go();
  }
  
  // Все геймдизайнеры
  Future<List<Designer>> getAll() async {
    return await select(designers).get();
  }

  // Все геймдизайнеры (поток)
  Stream<List<Designer>> watchAll() {
    return select(designers).watch();
  }

  // Геймдизайнер
  Future<Designer?> get(int designerId) async {
    return await (select(designers)..where((d) => d.id.equals(designerId))).getSingleOrNull();
  }
}
