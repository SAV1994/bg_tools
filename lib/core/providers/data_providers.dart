import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

// Шаблон
final countingTemplateDataProvider =
    FutureProvider.family<CountingTemplate?, int>((
      ref,
      countingTemplateId,
    ) async {
      final dao = ref.watch(countingTemplateDaoProvider);
      return await dao.get(countingTemplateId);
    });

// Полная информация о игре
final gameFullDataProvider = FutureProvider.family<GameFullData?, int>((
  ref,
  gameId,
) async {
  final dao = ref.watch(gameDaoProvider);
  return await dao.getFullInfo(gameId);
});

// Количество партий в игру
final gameSessionCountDataProvider = FutureProvider.family<int, int>((
  ref,
  gameId,
) async {
  final dao = ref.watch(gamingSessionDaoProvider);
  return await dao.getTotalCount(onlyIsFinished: true, gameId: gameId);
});

// Владелец приложения
final ownerDataProvider = FutureProvider<Gamer?>((ref) async {
  final dao = ref.watch(gamerDaoProvider);
  return dao.getOwner();
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

// Данные текущей сессии
final sessionDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return AppDataManager.loadActiveSession();
});

// Данные о прогрессе ранжирования
final ratingDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return AppDataManager.loadRatingProcess();
});

// Заметка
final noteDataProvider = FutureProvider.family<Note?, int>((ref, noteId) async {
  final dao = ref.watch(noteDaoProvider);
  return await dao.getSingle(noteId);
});
