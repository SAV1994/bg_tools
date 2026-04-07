import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
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
