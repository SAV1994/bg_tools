// Маппинг сценариев
import 'package:bg_tools/features/session_runner/scenarios/scenarios.dart';

final Map<String, dynamic> scenarioMapping = {
  // Распределение по местам
  '1.1.1.1': WPScenarioFP.scenario,
  '1.1.1.2': WPScenarioFP.scenario,
  '1.1.3.0': WithoutWPScenarioFP.scenario,
  '1.2.1.1': WPScenario.scenario,
  '1.2.1.2': WPScenario.scenario,
  '1.2.3.0': WithoutWPScenario.scenario,
  // Один победитель
  '2.1.3.0': OneWinnerScenario.scenario,
  // Кооператив
  '4.1.1.1': CoopScenarioFP.scenario,
  '4.1.1.2': CoopScenarioFP.scenario,
  '4.1.3.0': CoopScenarioFP.scenario,
  '4.2.1.1': CoopScenario.scenario,
  '4.2.1.2': CoopScenario.scenario,
  '4.2.3.0': CoopScenario.scenario,
  // Соло
  '5.0.1.1': SoloScenario.scenario,
  '5.0.1.2': SoloScenario.scenario,
  '5.0.3.0': SoloScenario.scenario,
};
