import 'package:bg_tools/core/providers/paginated_providers/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';

final gamingSessionsPaginatedProvider =
    AsyncNotifierProvider<GamingSessionsNotifier, List<dynamic>>(() {
      return GamingSessionsNotifier();
    });

class GamingSessionsNotifier extends BaseNotifier {
  @override
  bool reverseOrdering = true;
  bool onlyIsFinished = true;
  int? gameId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(gamingSessionDaoProvider);

    totalItems = await dao.getTotalCount(
      onlyIsFinished: onlyIsFinished,
      gameId: gameId,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      onlyIsFinished: onlyIsFinished,
      gameId: gameId,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByGame(int? id) async {
    gameId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  Future<void> toggleonlyIsFinished() async {
    onlyIsFinished = !onlyIsFinished;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    onlyIsFinished = true;
    gameId = null;
    state = await AsyncValue.guard(() => load());
  }
}
