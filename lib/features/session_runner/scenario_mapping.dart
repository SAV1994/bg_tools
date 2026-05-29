// Маппинг сценариев
import 'package:bg_tools/features/session_runner/scenarios/scenarios.dart';

final Map<String, dynamic> scenarioMapping = {
  // Распределение по местам
  '1.1.1': WPFPScenario.scenario,
  '1.1.2': RoundsFPScenario.scenario,
  '1.1.3': WithoutWPFPScenario.scenario,
  '1.2.1': WPScenario.scenario,
  '1.2.2': RoundsScenario.scenario,
  '1.2.3': WithoutWPScenario.scenario,
  // Один победитель
  '2.1.1': WPFPScenario.scenario,
  '2.1.2': RoundsFPScenario.scenario,
  '2.1.3': OneWinnerFPScenario.scenario,
  '2.2.1': WPScenario.scenario,
  '2.2.2': RoundsScenario.scenario,
  '2.2.3': OneWinnerScenario.scenario,
  // Кооператив
  '4.1.1': CoopFPScenario.scenario,
  '4.1.2': CoopRoundsFPScenario.scenario,
  '4.1.3': CoopFPScenario.scenario,
  '4.2.1': CoopScenario.scenario,
  '4.2.2': CoopRoundsScenario.scenario,
  '4.2.3': CoopScenario.scenario,
  // Соло
  '5.0.1': SoloScenario.scenario,
  '5.0.2': SoloRoundsScenario.scenario,
  '5.0.3': SoloScenario.scenario,
};
