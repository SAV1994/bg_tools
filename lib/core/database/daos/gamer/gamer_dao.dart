import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/gamer.dart';

part 'gamer_dao.g.dart';

@DriftAccessor(tables: [Gamers])
class GamerDao extends DatabaseAccessor<AppDatabase> with _$GamerDaoMixin {
  GamerDao(super.db);
  
  // Создание новой записи
  Future<int> create(GamersCompanion gamer) async {
    return await into(gamers).insert(gamer);
  }

  // Редактирование
  Future<bool> updInstance(int gamerId, GamersCompanion gamer) async {
    final updateResult = await (update(gamers)..where((g) => g.id.equals(gamerId))).write(gamer);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int gamerId) async {
    return await (delete(gamers)..where((g) => g.id.equals(gamerId))).go();
  }

  // Все игроки
  Future<List<Gamer>> getAll() async {
    return await (select(gamers)..where((g) => g.isOwner.equals(false))).get();
  }

  // Игрок
  Future<Gamer?> get(int gamerId) async {
    return await (select(gamers)..where((g) => g.id.equals(gamerId))).getSingleOrNull();
  }

  // Владелец
  Future<Gamer?> getOwner() async {
    return await (select(gamers)..where((g) => g.isOwner.equals(true))).getSingleOrNull();
  }
}
