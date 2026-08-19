import 'package:flutter/material.dart';

// Структура данных шага сценария
class ScenarioStep {
  final String title;
  final String description;
  final Widget Function(Map<String, dynamic> data, List<dynamic> counterData)
  contentBuilder;
  final Function(Map<String, dynamic> data) validator;

  ScenarioStep({
    required this.title,
    required this.description,
    required this.contentBuilder,
    required this.validator,
  });
}

// Структура данных сценария
class Scenario {
  final List<ScenarioStep> steps;

  Scenario({required this.steps});
}

// Структура данных сессии
const Map<String, dynamic> sessionInitialData = {
  'selector': null,
  'gameId': null,
  'expansionIds': [],
  'rootSessionId': null,

  'type': null,
  'firstPlayerStartType': null,
  'resultType': null,
  'generalDefeatType': null,
  'teamPointType': null,
  'pointType': null,
  'roundsType': null,
  'altVictoryType': null,
  'firstPlayerRoundType': null,
  'firstPlayerRoundPointType': null,
  'sequencePlayersMovesType': null,
  'gameHostType': null,
  'secretRolesDistributionType': null,
  'uniquenessRolesType': null,

  'step': 0,
  'totalSteps': null,

  'startedAt': null,
  'finishedAt': null,

  'gamers': [],

  'master': null,
  'secretRoles': [],

  'numberTeams': null,
  'teamsData': {},

  'round': 0,
  'lastRoundFirstPlayer': null,
  'totalRounds': null,
  'roundsScoreLimit': null,

  'resulScreenMode': null,
};
