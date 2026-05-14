import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';

// БД
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Художник (ДАО)
final artistDaoProvider = Provider<ArtistDao>((ref) {
  return ref.read(databaseProvider).artistDao;
});

// Шаблон (ДАО)
final countingTemplateDaoProvider = Provider<CountingTemplateDao>((ref) {
  return ref.read(databaseProvider).countingTemplateDao;
});

// Шаблон партии игры (ДАО)
final gamesCountingTemplatesDaoProvider = Provider<GamesCountingTemplatesDao>((
  ref,
) {
  return ref.read(databaseProvider).gamesCountingTemplatesDao;
});

// Геймдизайнер (ДАО)
final designerDaoProvider = Provider<DesignerDao>((ref) {
  return ref.read(databaseProvider).designerDao;
});

// Игра (ДАО)
final gameDaoProvider = Provider<GameDao>((ref) {
  return ref.read(databaseProvider).gameDao;
});

// Игрок (ДАО)
final gamerDaoProvider = Provider<GamerDao>((ref) {
  return ref.read(databaseProvider).gamerDao;
});

// Игровая сессия (ДАО)
final gamingSessionDaoProvider = Provider<GamingSessionDao>((ref) {
  return ref.read(databaseProvider).gamingSessionDao;
});

// Заметка (ДАО)
final noteDaoProvider = Provider<NoteDao>((ref) {
  return ref.read(databaseProvider).noteDao;
});

// Метка (ДАО)
final tagDaoProvider = Provider<TagDao>((ref) {
  return ref.read(databaseProvider).tagDao;
});
