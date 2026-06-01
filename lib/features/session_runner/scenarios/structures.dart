import 'package:flutter/material.dart';

// Структура данных шага сценария
class ScenarioStep {
  final String title;
  final String description;
  final Widget Function(Map<String, dynamic> data) contentBuilder;
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
  'teamPointType': null,
  'pointType': null,
  'altVictoryType': null,
  'firstPlayerRoundType': null,
  'sequencePlayersMovesType': null,

  'step': 0,
  'totalSteps': null,

  'startedAt': null,
  'finishedAt': null,

  'gamers': [],

  'round': 0,
  'lastRoundFirstPlayer': null,
  'totalRounds': null,

  'onlyGeneralScore': false,
  'generalScore': null,

  'resulScreenMode': null,

  'data': {},
};
