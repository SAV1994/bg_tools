// Маппинг сценариев
import 'package:bg_tools/features/session_runner/scenarios/scenarios.dart';

final Map<String, dynamic> scenarioMapping = {
  // Один победитель
  '2.1.3.0.0.0': OneWinnerScenario.scenario,
  // Кооператив
  '4.1.1.1.1.0': CoopScenarioFP.scenario,
  '4.1.1.1.2.0': CoopScenarioFP.scenario,
  '4.1.1.2.1.0': CoopScenarioFP.scenario,
  '4.1.1.2.2.0': CoopScenarioFP.scenario,
  '4.1.3.0.0.0': CoopScenarioFP.scenario,
  '4.2.1.1.1.0': CoopScenario.scenario,
  '4.2.1.1.2.0': CoopScenario.scenario,
  '4.2.1.2.1.0': CoopScenario.scenario,
  '4.2.1.2.2.0': CoopScenario.scenario,
  '4.2.3.0.0.0': CoopScenario.scenario,
  // Соло
  '5.0.1.1.1.0': SoloScenario.scenario,
  '5.0.1.1.2.0': SoloScenario.scenario,
  '5.0.1.2.1.0': SoloScenario.scenario,
  '5.0.1.2.2.0': SoloScenario.scenario,
  '5.0.3.0.0.0': SoloScenario.scenario,
};
