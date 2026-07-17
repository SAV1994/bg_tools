import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final gamersPaginatedProvider =
    AsyncNotifierProvider<GamersNotifier, List<dynamic>>(() {
      return GamersNotifier();
    });

class GamersNotifier extends BaseNotifier {
  @override
  Future<List<Gamer>> load() async {
    final dao = ref.read(gamerDaoProvider);

    totalItems = await dao.getTotalCount(searchQuery: searchQuery);

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      searchQuery: searchQuery,
    );
  }
}
