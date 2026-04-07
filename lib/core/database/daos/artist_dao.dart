import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/artist.dart';

part 'artist_dao.g.dart';

@DriftAccessor(tables: [Artists])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  ArtistDao(super.db);
  
  Future<int> create(ArtistsCompanion artist) async {
    return await into(artists).insert(artist);
  }
  
  Future<List<Artist>> getAll() async {
    return await select(artists).get();
  }

  Stream<List<Artist>> watchAll() {
    return select(artists).watch();
  }
}
