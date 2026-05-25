// Маппинг сценариев
import 'package:bg_tools/features/session_runner/scenarios/scenarios.dart';

final Map<String, dynamic> scenarioMapping = {
  '2.1.3.0.0.0': OneWinnerScenario.scenario,
  '5.0.1.1.1.0': SoloScenario.scenario,
  '5.0.1.1.2.0': SoloScenario.scenario,
  '5.0.1.2.1.0': SoloScenario.scenario,
  '5.0.1.2.2.0': SoloScenario.scenario,
  '5.0.3.0.0.0': SoloScenario.scenario,
};
