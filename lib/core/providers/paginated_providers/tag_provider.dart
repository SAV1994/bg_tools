import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final tagsPaginatedProvider =
    AsyncNotifierProvider<TagsNotifier, List<dynamic>>(() {
      return TagsNotifier();
    });

class TagsNotifier extends BaseNotifier {
  @override
  Future<List<Tag>> load() async {
    final dao = ref.read(tagDaoProvider);

    totalItems = await dao.getTotalCount(searchQuery: searchQuery);

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      searchQuery: searchQuery,
    );
  }
}
