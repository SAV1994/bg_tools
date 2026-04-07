import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/daos_exports.dart';

// БД
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Игрок (ДАО)
final gamerDaoProvider = Provider<GamerDao>((ref) {
  return ref.read(databaseProvider).gamerDao;
});

// Игра (ДАО)
final gameDaoProvider = Provider<GameDao>((ref) {
  return ref.read(databaseProvider).gameDao;
});

// Геймдизайнер (ДАО)
final designerDaoProvider = Provider<DesignerDao>((ref) {
  return ref.read(databaseProvider).designerDao;
});

// Художник (ДАО)
final artistDaoProvider = Provider<ArtistDao>((ref) {
  return ref.read(databaseProvider).artistDao;
});

// Метка (ДАО)
final tagDaoProvider = Provider<TagDao>((ref) {
  return ref.read(databaseProvider).tagDao;
});

// Игровая сессия (ДАО)
final gamingSessionDaoProvider = Provider<GamingSessionDao>((ref) {
  return ref.read(databaseProvider).gamingSessionDao;
});
