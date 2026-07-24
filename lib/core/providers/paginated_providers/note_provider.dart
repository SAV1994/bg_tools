import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final notesPaginatedProvider =
    AsyncNotifierProvider<NotesNotifier, List<dynamic>>(() {
      return NotesNotifier();
    });

class NotesNotifier extends BaseNotifier {
  int? gameId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(noteDaoProvider);

    totalItems = await dao.getTotalCount(
      gameId: gameId!,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      gameId: gameId!,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByGame(int? id) async {
    gameId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }
}
