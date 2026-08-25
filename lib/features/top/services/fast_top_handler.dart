import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/dataclasses.dart';
import 'package:bg_tools/features/top/services/base_top_handler.dart';

class FastRankingHandler extends BaseRankingHandler {
  @override
  Future<List<GameItem>> getCurrentPair() async {
    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();

    initialSteps = ratingData!['totalGames'];
    totalSteps = ratingData['totalGames'] - ratingData['rankingGames'].length;

    // Бинарный поиск позиции для вставки
    final int low = ratingData['data']['low'] ?? 0;
    final int high =
        ratingData['data']['high'] ?? ratingData['rankingGames'].length;
    final int mid = (low + high) ~/ 2;

    final String game1Id = ratingData['games'][0].toString();
    final Map<String, dynamic> game1Data = ratingData['gamesInfo'][game1Id];
    final String game2Id = ratingData['rankingGames'][mid].toString();
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
    int low = ratingData!['data']['low'] ?? 0;
    int high = ratingData['data']['high'] ?? ratingData['rankingGames'].length;
    final mid = (low + high) ~/ 2;

    final String game1Id = ratingData['games'][0].toString();

    if (game1Id == selected.id) {
      // выше по рейтингу - идем в левую часть
      high = mid;
    } else {
      // ниже по рейтингу - идем в правую часть
      low = mid + 1;
    }

    if (low >= high) {
      final int gameId = ratingData['games'].removeAt(0);
      ratingData['rankingGames'].insert(low, gameId);
      ratingData['data'] = {};
      totalSteps = ratingData['totalGames'] - ratingData['rankingGames'].length;
    } else {
      ratingData['data']['low'] = low;
      ratingData['data']['high'] = high;
    }

    await AppDataManager.saveRatingProcess(ratingData);
  }

  @override
  Future<void> finishRanking(WidgetRef ref) async {
    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();

    final RatingDao ratingDao = ref.read(ratingDaoProvider);

    final List<RatingGamePreSaveData> gamesData = [];
    for (final ratingItem in ratingData!['rankingGames'].asMap().entries) {
      gamesData.add(
        RatingGamePreSaveData(
          gameId: ratingItem.value,
          score: double.parse(
            ((ratingData['totalGames'] - ratingItem.key) /
                    ratingData['totalGames'] *
                    100)
                .toStringAsFixed(2),
          ),
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
