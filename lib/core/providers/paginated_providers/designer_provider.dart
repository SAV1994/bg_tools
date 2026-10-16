import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/dataclasses/designer_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final designersPaginatedProvider =
    AsyncNotifierProvider<DesignersNotifier, List<dynamic>>(() {
      return DesignersNotifier();
    });

class DesignersNotifier extends BaseNotifier {
  @override
  Future<List<DesignertData>> load() async {
    final dao = ref.read(designerDaoProvider);

    totalItems = await dao.getTotalCount(searchQuery: searchQuery);

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      searchQuery: searchQuery,
    );
  }
}
