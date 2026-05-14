import 'dart:convert';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/features/session_runner/scenario_mapping.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

Future<void> initSessionData(
  GamesCountingTemplatesData gamesCountingTemplatesData,
) async {
  final Map<String, dynamic> sessionData =
      json.decode(json.encode(sessionInitialData)) as Map<String, dynamic>;
  final Map<String, dynamic> countingTemplateData = jsonDecode(
    gamesCountingTemplatesData.countingTemplate.data,
  );
  final String selector =
      '${countingTemplateData['gameType']}.${countingTemplateData['firstPlayerStartType']}.'
      '${countingTemplateData['resultType']}.${countingTemplateData['pointType'] ?? 0}.'
      '${countingTemplateData['FirstPlayerRoundType'] ?? 0}';
  final Scenario scenario = scenarioMapping[selector];

  sessionData['selector'] = selector;
  sessionData['FirstPlayerRoundType'] =
      countingTemplateData['FirstPlayerRoundType'];
  sessionData['totalSteps'] = scenario.steps.length;
  sessionData['gameId'] =
      gamesCountingTemplatesData.gamesCountingTemplate.gameId;
  sessionData['expansionIds'] = gamesCountingTemplatesData.selectedexpansionIds
      .toList();

  await AppDataManager.saveActiveSession(sessionData);
}
