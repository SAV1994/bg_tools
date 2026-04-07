import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/artist_dao.dart';
import 'package:bg_tools/core/database/daos/designer_dao.dart';
import 'package:bg_tools/core/database/daos/game_dao.dart';
import 'package:bg_tools/core/database/daos/tag_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final gameDaoProvider = Provider<GameDao>((ref) {
  return ref.read(databaseProvider).gameDao;
});

final designerDaoProvider = Provider<DesignerDao>((ref) {
  return ref.read(databaseProvider).designerDao;
});

final artistDaoProvider = Provider<ArtistDao>((ref) {
  return ref.read(databaseProvider).artistDao;
});

final tagDaoProvider = Provider<TagDao>((ref) {
  return ref.read(databaseProvider).tagDao;
});
