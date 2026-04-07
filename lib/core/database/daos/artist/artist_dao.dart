import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/artist.dart';

part 'artist_dao.g.dart';

@DriftAccessor(tables: [Artists])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  ArtistDao(super.db);
  
  // Создание новой записи
  Future<int> create(ArtistsCompanion artist) async {
    return await into(artists).insert(artist);
  }

  // Редактирование
  Future<bool> updInstance(int artistId, ArtistsCompanion artist) async {
    final updateResult = await (update(artists)..where((a) => a.id.equals(artistId))).write(artist);
    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int artistId) async {
    return await (delete(artists)..where((a) => a.id.equals(artistId))).go();
  }
  
  // Все художники
  Future<List<Artist>> getAll() async {
    return await select(artists).get();
  }

  // Все художники (поток)
  Stream<List<Artist>> watchAll() {
    return select(artists).watch();
  }

  // Художник
  Future<Artist?> get(int artistId) async {
    return await (select(artists)..where((a) => a.id.equals(artistId))).getSingleOrNull();
  }
}
