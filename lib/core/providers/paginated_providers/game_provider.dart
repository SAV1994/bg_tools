import 'package:bg_tools/core/providers/paginated_providers/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';

final gamesPaginatedProvider =
    AsyncNotifierProvider<GamesNotifier, List<dynamic>>(() {
      return GamesNotifier();
    });

class GamesNotifier extends BaseNotifier {
  bool onlyFavorite = false;
  bool onlyStandalone = true;
  int? artistId;
  int? designerId;
  int? tagId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(gameDaoProvider);

    totalItems = await dao.getTotalCount(
      onlyFavorite: onlyFavorite,
      onlyStandalone: onlyStandalone,
      artistId: artistId,
      designerId: designerId,
      tagId: tagId,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      onlyFavorite: onlyFavorite,
      onlyStandalone: onlyStandalone,
      artistId: artistId,
      designerId: designerId,
      tagId: tagId,
      searchQuery: searchQuery,
    );
  }

  Future<void> toggleOnlyFavorite() async {
    onlyFavorite = !onlyFavorite;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> toggleOnlyStandalone() async {
    onlyStandalone = !onlyStandalone;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> filterByArtist(int? id) async {
    artistId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> filterByDesigner(int? id) async {
    designerId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> filterByTag(int? id) async {
    tagId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    onlyFavorite = false;
    onlyStandalone = true;
    artistId = null;
    designerId = null;
    tagId = null;
    state = await AsyncValue.guard(() => load());
  }
}
