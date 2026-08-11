import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getCountingTemplateData(
  CountingTemplate countingTemplate,
) {
  return {
    'id': countingTemplate.id,
    'name': countingTemplate.name,
    'description': countingTemplate.description,
    'data': countingTemplate.data,
  };
}

Map<String, dynamic> getGamesCountingTemplateData(
  GamesCountingTemplate gamesCountingTemplate,
) {
  return {
    'id': gamesCountingTemplate.id,
    'name': gamesCountingTemplate.name,
    'data': gamesCountingTemplate.data,
    'gameId': gamesCountingTemplate.gameId,
    'countingTemplateId': gamesCountingTemplate.countingTemplateId,
  };
}
