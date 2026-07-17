import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final countingTemplatesPaginatedProvider =
    AsyncNotifierProvider<CountingTemplatesNotifier, List<dynamic>>(() {
      return CountingTemplatesNotifier();
    });

class CountingTemplatesNotifier extends BaseNotifier {
  int? gameTypeId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(countingTemplateDaoProvider);

    totalItems = await dao.getTotalCount(
      gameTypeId: gameTypeId,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      gameTypeId: gameTypeId,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByGameType(int? id) async {
    gameTypeId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    gameTypeId = null;
    state = await AsyncValue.guard(() => load());
  }
}
