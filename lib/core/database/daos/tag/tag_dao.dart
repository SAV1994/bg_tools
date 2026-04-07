import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);
  
  // Создание новой записи
  Future<int> create(TagsCompanion tag) async {
    return await into(tags).insert(tag);
  }

  // Редактирование
  Future<bool> updInstance(int tagId, TagsCompanion tag) async {
    final updateResult = await (update(tags)..where((t) => t.id.equals(tagId))).write(tag);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int tagId) async {
    return await (delete(tags)..where((t) => t.id.equals(tagId))).go();
  }
  
  // Все метки
  Future<List<Tag>> getAll() async {
    return await select(tags).get();
  }

  // Все метки (поток)
  Stream<List<Tag>> watchAll() {
    return select(tags).watch();
  }

  // Метка
  Future<Tag?> get(int tagId) async {
    return await (select(tags)..where((t) => t.id.equals(tagId))).getSingleOrNull();
  }
}
