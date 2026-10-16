import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getRandomListData(RandomList randomList) {
  return {
    'id': randomList.id,
    'name': randomList.name,
    'randomSetupId': randomList.randomSetupId,
    'gameId': randomList.gameId,
    'type': randomList.type,
    'isUnique': randomList.isUnique,
    'itemsNum': randomList.itemsNum,
  };
}
