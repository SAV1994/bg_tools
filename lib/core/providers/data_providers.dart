import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

final designersDataProvider = StreamProvider<List<Designer>>((ref) {
  final designerDao = ref.watch(designerDaoProvider);
  return designerDao.watchAll(); // Stream автоматически обновляется
});

final artistsDataProvider = StreamProvider<List<Artist>>((ref) {
  final artistDao = ref.watch(artistDaoProvider);
  return artistDao.watchAll(); // Stream автоматически обновляется
});

final tagsDataProvider = StreamProvider<List<Tag>>((ref) {
  final tagDao = ref.watch(tagDaoProvider);
  return tagDao.watchAll(); // Stream автоматически обновляется
});

final gameFullDataProvider = FutureProvider.family<GameFullData?, int>((ref, id) async {
  final dao = ref.watch(gameDaoProvider);
  return await dao.getFullInfo(id);
});

final gamingSessionDataProvider = FutureProvider.family<GamingSessionFullData?, int>((ref, id) async {
  final dao = ref.watch(gamingSessionDaoProvider);
  return await dao.getFullInfo(id);
});
