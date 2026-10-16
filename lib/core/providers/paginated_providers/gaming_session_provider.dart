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
  bool? isFinished = true;
  int? gameId;
  DateTime? periodStart;
  DateTime? periodEnd;
  int? gameTypeId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(gamingSessionDaoProvider);

    totalItems = await dao.getTotalCount(
      isFinished: isFinished,
      gameId: gameId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      gameTypeId: gameTypeId,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      isFinished: isFinished,
      gameId: gameId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      gameTypeId: gameTypeId,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByGame(int? id) async {
    gameId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    isFinished = true;
    gameId = null;
    periodStart = null;
    periodEnd = null;
    gameTypeId = null;
    reverseOrdering = true;
  }

  int countActiveFilters() {
    int counter = 0;
    if (isFinished != null) {
      counter += 1;
    }
    if (gameId != null) {
      counter += 1;
    }
    if (periodStart != null) {
      counter += 1;
    }
    if (periodEnd != null) {
      counter += 1;
    }
    if (gameTypeId != null) {
      counter += 1;
    }

    return counter;
  }
}
