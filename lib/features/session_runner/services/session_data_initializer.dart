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

  sessionData['type'] = countingTemplateData['gameType'];
  sessionData['resultType'] = countingTemplateData['resultType'];
  sessionData['firstPlayerStartType'] =
      countingTemplateData['firstPlayerStartType'];
  sessionData['pointType'] = countingTemplateData['pointType'];
  sessionData['altVictoryType'] = countingTemplateData['altVictoryType'];
  sessionData['firstPlayerRoundType'] =
      countingTemplateData['firstPlayerRoundType'];

  final String selector =
      '${sessionData['type']}.${sessionData['firstPlayerStartType'] ?? 0}.'
      '${sessionData['resultType']}.${sessionData['pointType'] ?? 0}.'
      '${sessionData['altVictoryType'] ?? 0}.${sessionData['firstPlayerRoundType'] ?? 0}';
  final Scenario scenario = scenarioMapping[selector];
  sessionData['selector'] = selector;

  sessionData['totalSteps'] = scenario.steps.length;
  sessionData['gameId'] =
      gamesCountingTemplatesData.gamesCountingTemplate.gameId;
  sessionData['expansionIds'] = gamesCountingTemplatesData.selectedexpansionIds
      .toList();

  await AppDataManager.saveActiveSession(sessionData);
}
