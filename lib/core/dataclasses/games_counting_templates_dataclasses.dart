// Класс для хранения базовых данных о шаблоне партии игры
import 'package:bg_tools/core/database/app_database.dart';

class GamesCountingTemplatesData {
  final GamesCountingTemplate gamesCountingTemplate;
  final CountingTemplate countingTemplate;
  final List<Game> expansions;
  final Set<int> selectedexpansionIds;

  GamesCountingTemplatesData({
    required this.gamesCountingTemplate,
    required this.countingTemplate,
    required this.expansions,
    required this.selectedexpansionIds,
  });
}
