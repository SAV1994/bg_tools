import 'package:bg_tools/features/session_runner/scenarios/steps.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

// Распределение по местам
class WithoutWPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      sessionStopStep,
      resultStep,
      finalStep,
    ],
  );
}

// Распределение по местам (есть порядок ходов)
class WithoutWPFPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      resultStep,
      finalStep,
    ],
  );
}

// Распределение по местам с ПО
class WPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      resultStep,
      finalStep,
    ],
  );
}

// Распределение по местам с ПО (есть порядок ходов)
class WPFPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      resultStep,
      finalStep,
    ],
  );
}

// Один победитель
class OneWinnerScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      sessionStopStep,
      oneWinnerSelectStep,
      finalStep,
    ],
  );
}

// Один победитель (есть порядок ходов)
class OneWinnerFPScenario {
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

// Кооп
class CoopScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      sessionStopStep,
      coopResultStep,
      finalStep,
    ],
  );
}

// Кооп (есть порядок ходов)
class CoopFPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      coopResultStep,
      finalStep,
    ],
  );
}
