import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getRandomSetupData(RandomSetup randomSetup) {
  return {
    'id': randomSetup.id,
    'name': randomSetup.name,
    'gameId': randomSetup.gameId,
  };
}
