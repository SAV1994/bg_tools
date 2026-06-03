import 'package:bg_tools/features/session_runner/scenarios/steps.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

// 1 Распределение по местам
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

// 1 Распределение по местам (есть порядок ходов)
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

// 1 Распределение по местам с ПО
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

// 1 Распределение по местам с ПО + раунды
class RoundsScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      gamersSelectStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      scoreInputStep,
      resultStep,
      finalStep,
    ],
  );
}

// 1 Распределение по местам с ПО (есть порядок ходов)
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

// 1 Распределение по местам с ПО (есть порядок ходов) + раунды
class RoundsFPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      scoreInputStep,
      resultStep,
      finalStep,
    ],
  );
}

// 2 Один победитель
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

// 2 Один победитель (есть порядок ходов)
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

// 3 Распределение по местам с ПО (есть порядок ходов) + раунды
class TeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      scoreInputStep,
      resultStep,
      finalStep,
    ],
  );
}

// 4 Кооп
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

// 4 Кооп + раунды
class CoopRoundsScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      gamersSelectStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      coopResultStep,
      finalStep,
    ],
  );
}

// 4 Кооп (есть порядок ходов)
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

// 4 Кооп (есть порядок ходов) + раунды
class CoopRoundsFPScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      coopResultStep,
      finalStep,
    ],
  );
}

// 5 Соло
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

// 5 Соло + раунды
class SoloRoundsScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberRoundsStep,
      gamersSelectStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      soloResultStep,
      finalStep,
    ],
  );
}
