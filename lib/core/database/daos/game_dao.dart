import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/game.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [Games])
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);
  
  // CREATE
  Future<int> create(GamesCompanion game) async {
    return await into(games).insert(game);
  }
  
  // READ
  Future<List<Game>> getAll() async {
    return await select(games).get();
  }

  Future<List<Game>> getAllBase({int? excludeId}) async {
    var query = select(games)..where((g) => g.parentId.isNull());

    if (excludeId != null) {
      query = query..where((g) => g.id.isNotValue(excludeId));
    }
    
    return await query.get();
  }  
  
  Future<void> claen() async {
    await delete(games).go();
  }
}
