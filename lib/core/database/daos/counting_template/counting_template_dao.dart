import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/counting_template.dart';

part 'counting_template_dao.g.dart';

@DriftAccessor(tables: [CountingTemplates])
class CountingTemplateDao extends DatabaseAccessor<AppDatabase>
    with _$CountingTemplateDaoMixin {
  CountingTemplateDao(super.db);

  // Создание новой записи
  Future<int> create(CountingTemplatesCompanion countingTemplate) async {
    return await into(countingTemplates).insert(countingTemplate);
  }

  // Редактирование
  Future<bool> updInstance(
    int countingTemplateId,
    CountingTemplatesCompanion countingTemplate,
  ) async {
    final updateResult = await (update(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).write(countingTemplate);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int countingTemplateId) async {
    return await (delete(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).go();
  }

  // Все шаблоны
  Future<List<CountingTemplate>> getAll() async {
    return await select(countingTemplates).get();
  }

  // Все геймдизайнеры (поток)
  Stream<List<CountingTemplate>> watchAll() {
    return select(countingTemplates).watch();
  }

  // Геймдизайнер
  Future<CountingTemplate?> get(int countingTemplateId) async {
    return await (select(
      countingTemplates,
    )..where((c) => c.id.equals(countingTemplateId))).getSingleOrNull();
  }
}
