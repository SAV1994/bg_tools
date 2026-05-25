import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

// Художники
final artistsDataProvider = StreamProvider<List<Artist>>((ref) {
  final artistDao = ref.watch(artistDaoProvider);
  return artistDao.watchAll(); // Stream автоматически обновляется
});

// Шаблоны
final countingTemplatesDataProvider = StreamProvider<List<CountingTemplate>>((
  ref,
) {
  final countingTemplateDao = ref.watch(countingTemplateDaoProvider);
  return countingTemplateDao.watchAll(); // Stream автоматически обновляется
});

// Шаблон
final countingTemplateDataProvider =
    FutureProvider.family<CountingTemplate?, int>((
      ref,
      countingTemplateId,
    ) async {
      final dao = ref.watch(countingTemplateDaoProvider);
      return await dao.get(countingTemplateId);
    });

// Шабоны партий игры
final gamesCountingTemplatesDataProvider =
    StreamProvider.family<List<GamesCountingTemplatesData>, int>((ref, gameId) {
      final gamesCountingTemplatesDao = ref.watch(
        gamesCountingTemplatesDaoProvider,
      );
      return gamesCountingTemplatesDao.watchAll(
        gameId,
      ); // Stream автоматически обновляется
    });

// Геймдизайнеры
final designersDataProvider = StreamProvider<List<Designer>>((ref) {
  final designerDao = ref.watch(designerDaoProvider);
  return designerDao.watchAll(); // Stream автоматически обновляется
});

// Игры
final gamesDataProvider = StreamProvider<List<Game>>((ref) {
  final gameDao = ref.watch(gameDaoProvider);
  return gameDao.watchAll(); // Stream автоматически обновляется
});

// Полная информация о игре
final gameFullDataProvider = FutureProvider.family<GameFullData?, int>((
  ref,
  gameId,
) async {
  final dao = ref.watch(gameDaoProvider);
  return await dao.getFullInfo(gameId);
});

// Владелец приложения
final ownerDataProvider = FutureProvider<Gamer?>((ref) async {
  final dao = ref.watch(gamerDaoProvider);
  return dao.getOwner();
});

// Игровые сессии
final gamingSessionDataProvider = StreamProvider<List<GamingSessionData>>((
  ref,
) {
  final gamingSessionDao = ref.watch(gamingSessionDaoProvider);
  return gamingSessionDao.watchAll(); // Stream автоматически обновляется
});

// Полная информация об игровой сессии
final gamingSessionFullDataProvider =
    FutureProvider.family<GamingSessionFullData?, int>((
      ref,
      gamingSessionId,
    ) async {
      final dao = ref.watch(gamingSessionDaoProvider);
      return await dao.getFullInfo(gamingSessionId);
    });

// Заметки по игре
final notesForGameDataProvider = FutureProvider.family<List<Note>, int>((
  ref,
  gameId,
) async {
  final dao = ref.watch(noteDaoProvider);
  return await dao.getAll(gameId);
});

// Метки
final tagsDataProvider = StreamProvider<List<Tag>>((ref) {
  final tagDao = ref.watch(tagDaoProvider);
  return tagDao.watchAll(); // Stream автоматически обновляется
});

// Данные текущей сессии
final sessionDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return AppDataManager.loadActiveSession();
});
