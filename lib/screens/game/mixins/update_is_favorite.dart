import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';

mixin UpdateIsFaforiteMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  Future<void> updateIsFavorite(Game game) async {
    final gameDao = ref.read(gameDaoProvider);
    await gameDao.updateIsFavorite(game.id, !game.isFavorite);

    ref.read(gamesPaginatedProvider.notifier).refresh();
    ref.invalidate(gameFullDataProvider);

    setState(() {});
  }
}
