import 'package:flutter/material.dart';

// Структура данных шага сценария
class ScenarioStep {
  final String title;
  final String description;
  final Widget Function(Map<String, dynamic> data) contentBuilder;
  final Function(Map<String, dynamic> data) validator;
  final Map<String, dynamic> initialData;

  ScenarioStep({
    required this.title,
    required this.description,
    required this.contentBuilder,
    required this.validator,
    required this.initialData,
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
  'FirstPlayerRoundType': null,
  'step': 0,
  'totalSteps': null,
  'gameId': null,
  'expansionIds': [],
  'rootSessionId': null,
  'startedAt': null,
  'finishedAt': null,
  'gamers': [],
  'round': 0,
  'totalRounds': null,
  'data': {},
};
