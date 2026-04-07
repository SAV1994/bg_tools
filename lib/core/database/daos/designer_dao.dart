import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/designer.dart';

part 'designer_dao.g.dart';

@DriftAccessor(tables: [Designers])
class DesignerDao extends DatabaseAccessor<AppDatabase> with _$DesignerDaoMixin {
  DesignerDao(super.db);
  
  Future<int> create(DesignersCompanion designer) async {
    return await into(designers).insert(designer);
  }
  
  Future<List<Designer>> getAll() async {
    return await select(designers).get();
  }

  Stream<List<Designer>> watchAll() {
    return select(designers).watch();
  }
}
