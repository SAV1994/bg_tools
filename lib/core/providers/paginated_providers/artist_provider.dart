import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final artistsPaginatedProvider =
    AsyncNotifierProvider<ArtistsNotifier, List<dynamic>>(() {
      return ArtistsNotifier();
    });

class ArtistsNotifier extends BaseNotifier {
  @override
  Future<List<Artist>> load() async {
    final dao = ref.read(artistDaoProvider);

    totalItems = await dao.getTotalCount(searchQuery: searchQuery);

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      searchQuery: searchQuery,
    );
  }
}
