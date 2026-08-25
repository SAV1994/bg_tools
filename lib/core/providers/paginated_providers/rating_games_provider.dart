import 'package:bg_tools/core/providers/paginated_providers/base.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';

final ratingsGamesPaginatedProvider =
    AsyncNotifierProvider<RatingGamesNotifier, List<dynamic>>(() {
      return RatingGamesNotifier();
    });

class RatingGamesNotifier extends BaseNotifier {
  int? ratingId;
  TopTypeEnum ratingType = TopTypeEnum.common;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(ratingDaoProvider);

    totalItems = await dao.getTotalGamesCount(
      ratingId: ratingId!,
      searchQuery: searchQuery,
    );

    return await dao.getPaginatedGames(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      ratingType: ratingType,
      ratingId: ratingId!,
      searchQuery: searchQuery,
    );
  }

  Future<void> setTopType(TopTypeEnum topType) async {
    ratingType = topType;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> setRatingId(int? id) async {
    ratingId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    ratingType = TopTypeEnum.common;
    ratingId = null;
    state = await AsyncValue.guard(() => load());
  }
}
