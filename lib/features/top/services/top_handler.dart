import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/custom_exceptions.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/dataclasses.dart';
import 'package:bg_tools/features/top/services/base_top_handler.dart';

class RankingHandler extends BaseRankingHandler {
  @override
  Future<List<GameItem>> getCurrentPair() async {
    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();
    if (ratingData == null) {
      throw ValidationException('Данные ранжирования не инициализированы');
    }

    initialSteps = ratingData['totalPairs'];
    totalSteps = ratingData['pairs'].length;

    final String game1Id = ratingData['pairs'][0][0].toString();
    final Map<String, dynamic> game1Data = ratingData['gamesInfo'][game1Id];
    final String game2Id = ratingData['pairs'][0][1].toString();
    final Map<String, dynamic> game2Data = ratingData['gamesInfo'][game2Id];

    return [
      GameItem(
        id: game1Id,
        name: game1Data['name'],
        imagePath: game1Data['imagePath'],
      ),
      GameItem(
        id: game2Id,
        name: game2Data['name'],
        imagePath: game2Data['imagePath'],
      ),
    ];
  }

  @override
  Future<void> saveSelection(GameItem selected) async {
    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();
    if (ratingData != null) {
      ratingData['gamesInfo'][selected.id]['score'] += 1;
      ratingData['pairs'].removeAt(0);

      totalSteps = ratingData['pairs'].length;

      await AppDataManager.saveRatingProcess(ratingData);
    }
  }

  @override
  Future<void> finishRanking(WidgetRef ref) async {
    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();
    if (ratingData != null) {
      final List<Map<String, dynamic>> gamesInfo = [];
      ratingData['gamesInfo'].entries.forEach((entry) {
        gamesInfo.add({
          'gameId': int.parse(entry.key),
          'score': double.parse(
            (entry.value['score'] / (ratingData['totalGames'] - 1) * 100)
                .toStringAsFixed(2),
          ),
        });
      });
      gamesInfo.sort((a, b) => b['score'].compareTo(a['score']));

      final RatingDao ratingDao = ref.read(ratingDaoProvider);
      final List<RatingGamePreSaveData> gamesData = [];
      for (final ratingItem in gamesInfo.asMap().entries) {
        gamesData.add(
          RatingGamePreSaveData(
            gameId: ratingItem.value['gameId'],
            score: ratingItem.value['score'],
            place: ratingItem.key + 1,
          ),
        );
      }

      await ratingDao.create(
        TopTypeEnum.fromId(ratingData['topType']),
        RatingsCompanion(
          year: Value(ratingData['year']),
          month: Value(ratingData['month']),
          isActual: Value(true),
          data: Value(jsonEncode({'engine': ratingData['engine']})),
          artistId: Value(ratingData['artistId']),
          designerId: Value(ratingData['designerId']),
          tagId: Value(ratingData['tagId']),
        ),
        gamesData,
      );

      await AppDataManager.clearRatingProcess();

      ref.read(ratingsPaginatedProvider.notifier).refresh();
    }
  }
}
