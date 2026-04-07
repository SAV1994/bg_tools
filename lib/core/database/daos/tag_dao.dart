import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);
  
  Future<int> create(TagsCompanion tag) async {
    return await into(tags).insert(tag);
  }
  
  Future<List<Tag>> getAll() async {
    return await select(tags).get();
  }

  Stream<List<Tag>> watchAll() {
    return select(tags).watch();
  }
}
