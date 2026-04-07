import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/daos_exports.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final gamerDaoProvider = Provider<GamerDao>((ref) {
  return ref.read(databaseProvider).gamerDao;
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

final gamingSessionDaoProvider = Provider<GamingSessionDao>((ref) {
  return ref.read(databaseProvider).gamingSessionDao;
});
