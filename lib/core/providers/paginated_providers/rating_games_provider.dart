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
  int? startYear;
  int? endYear;
  double? startRating;
  double? endRating;
  int? numPlayers;
  bool? isPlayed;
  bool? isInCollection = true;
  bool? isFavorite;
  Set<int> artistIds = {};
  Set<int> designerIds = {};
  Set<int> tagIds = {};

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(ratingDaoProvider);

    totalItems = await dao.getTotalGamesCount(
      ratingId: ratingId!,
      startYear: startYear,
      endYear: endYear,
      startRating: startRating,
      endRating: endRating,
      numPlayers: numPlayers,
      isPlayed: isPlayed,
      isInCollection: isInCollection,
      isFavorite: isFavorite,
      artistIds: artistIds,
      designerIds: designerIds,
      tagIds: tagIds,
      searchQuery: searchQuery,
    );

    return await dao.getPaginatedGames(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      ratingType: ratingType,
      ratingId: ratingId!,
      startYear: startYear,
      endYear: endYear,
      startRating: startRating,
      endRating: endRating,
      numPlayers: numPlayers,
      isPlayed: isPlayed,
      isInCollection: isInCollection,
      isFavorite: isFavorite,
      artistIds: artistIds,
      designerIds: designerIds,
      tagIds: tagIds,
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
    startYear = null;
    endYear = null;
    startRating = null;
    endRating = null;
    numPlayers = null;
    isPlayed = null;
    isInCollection = true;
    isFavorite = null;
    artistIds = {};
    designerIds = {};
    tagIds = {};
  }

  int countActiveFilters() {
    int counter = 0;
    if (startYear != null || endYear != null) {
      counter += 1;
    }
    if (startRating != null || endRating != null) {
      counter += 1;
    }
    if (numPlayers != null) {
      counter += 1;
    }
    if (isPlayed != null) {
      counter += 1;
    }
    if (isInCollection != null) {
      counter += 1;
    }
    if (isFavorite != null) {
      counter += 1;
    }
    if (artistIds.isNotEmpty) {
      counter += 1;
    }
    if (designerIds.isNotEmpty) {
      counter += 1;
    }
    if (tagIds.isNotEmpty) {
      counter += 1;
    }

    return counter;
  }
}
