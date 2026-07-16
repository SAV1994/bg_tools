import 'dart:convert';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/utils/initial_team_data.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
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
  final Map<String, dynamic> gameData = jsonDecode(
    gamesCountingTemplatesData.gamesCountingTemplate.data!,
  );

  sessionData['type'] = countingTemplateData['gameType'] ?? 0;
  sessionData['firstPlayerStartType'] =
      countingTemplateData['firstPlayerStartType'] ?? 0;
  sessionData['resultType'] = countingTemplateData['resultType'] ?? 0;
  sessionData['teamPointType'] = countingTemplateData['teamPointType'] ?? 0;
  sessionData['pointType'] = countingTemplateData['pointType'] ?? 0;
  sessionData['roundsType'] = countingTemplateData['roundsType'] ?? 0;
  sessionData['altVictoryType'] = countingTemplateData['altVictoryType'] ?? 0;
  sessionData['firstPlayerRoundType'] =
      countingTemplateData['firstPlayerRoundType'] ?? 0;
  sessionData['sequencePlayersMovesType'] =
      countingTemplateData['sequencePlayersMovesType'] ?? 0;
  sessionData['gameHostType'] = countingTemplateData['gameHostType'] ?? 0;
  sessionData['secretRolesDistributionType'] =
      countingTemplateData['secretRolesDistributionType'] ?? 0;

  sessionData['roundsScoreLimit'] = gameData['roundsScoreLimit'];
  sessionData['secretRolesConfig'] = gameData['secretRolesConfig'];

  late final String selector;
  if (sessionData['type'] == GameTypeEnum.secretRoles.id) {
    selector =
        '${sessionData['type']}.${sessionData['gameHostType']}.'
        '${sessionData['secretRolesDistributionType']}';
  } else {
    selector =
        '${sessionData['type']}.${sessionData['firstPlayerStartType']}.'
        '${sessionData['resultType']}';
  }

  final Scenario scenario = scenarioMapping[selector];
  sessionData['selector'] = selector;

  sessionData['totalSteps'] = scenario.steps.length;
  sessionData['gameId'] =
      gamesCountingTemplatesData.gamesCountingTemplate.gameId;
  sessionData['expansionIds'] = gamesCountingTemplatesData.selectedexpansionIds
      .toList();

  if ([
    GameTypeEnum.solo.id,
    GameTypeEnum.coop.id,
  ].contains(sessionData['type'])) {
    final TeamsEnum teamEnum = TeamsEnum.red;
    setIniialTeamData(sessionData['teamsData'], teamEnum.id);
  }

  if (sessionData['type'] == GameTypeEnum.secretTeams.id) {
    for (final Map<String, dynamic> teamData
        in sessionData['secretRolesConfig']) {
      setIniialTeamData(
        sessionData['teamsData'],
        teamData['team'],
        name: teamData['name'],
      );
      sessionData['numberTeams'] = sessionData['teamsData'].keys.length;
    }
  }

  await AppDataManager.saveActiveSession(sessionData);
}
