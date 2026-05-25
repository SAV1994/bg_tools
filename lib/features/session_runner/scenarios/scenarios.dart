import 'package:bg_tools/features/session_runner/scenarios/steps.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

// Один победитель, без подсчёта очков
class OneWinnerScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      oneWinnerSelectStep,
      finalStep,
    ],
  );
}

// Соло
class SoloScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      sessionStopStep,
      soloResultStep,
      finalStep,
    ],
  );
}
