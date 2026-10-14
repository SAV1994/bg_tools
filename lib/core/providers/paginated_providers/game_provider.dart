import 'package:bg_tools/core/providers/paginated_providers/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';

final gamesPaginatedProvider =
    AsyncNotifierProvider<GamesNotifier, List<dynamic>>(() {
      return GamesNotifier();
    });

class GamesNotifier extends BaseNotifier {
  int? startYear;
  int? endYear;
  double? startRating;
  double? endRating;
  int? numPlayers;
  bool? isPlayed;
  bool? isInCollection = true;
  bool? isFavorite;
  bool? isStandalone = true;
  Set<int> baseIds = {};
  Set<int> artistIds = {};
  Set<int> designerIds = {};
  Set<int> tagIds = {};

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(gameDaoProvider);

    totalItems = await dao.getTotalCount(
      startYear: startYear,
      endYear: endYear,
      startRating: startRating,
      endRating: endRating,
      numPlayers: numPlayers,
      isPlayed: isPlayed,
      isInCollection: isInCollection,
      isFavorite: isFavorite,
      isStandalone: isStandalone,
      baseIds: baseIds,
      artistIds: artistIds,
      designerIds: designerIds,
      tagIds: tagIds,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      startYear: startYear,
      endYear: endYear,
      startRating: startRating,
      endRating: endRating,
      numPlayers: numPlayers,
      isPlayed: isPlayed,
      isInCollection: isInCollection,
      isFavorite: isFavorite,
      isStandalone: isStandalone,
      baseIds: baseIds,
      artistIds: artistIds,
      designerIds: designerIds,
      tagIds: tagIds,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByArtist(int id) async {
    artistIds = {id};
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> filterByDesigner(int id) async {
    designerIds = {id};
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> filterByTag(int id) async {
    tagIds = {id};
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    startYear = null;
    endYear = null;
    startRating = null;
    endRating = null;
    numPlayers = null;
    isPlayed = null;
    isInCollection = true;
    isFavorite = null;
    isStandalone = true;
    baseIds = {};
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
    if (isStandalone != null) {
      counter += 1;
    }
    if (baseIds.isNotEmpty) {
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
