import 'package:bg_tools/features/session_runner/scenarios/steps.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

// 1 Распределение по местам
class ClassicScenario {
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
class FpClassicScenario {
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
class WpClassicScenario {
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
class RoundsClassicScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
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
class WpFpClassicScenario {
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
class RoundsFpClassicScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
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
class FpOneWinnerScenario {
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

// 3 Командная игра (есть 2 место)
class TeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      sessionStopStep,
      teamResultStep,
      finalStep,
    ],
  );
}

// 3 Командная игра (есть 2 место) (есть порядок ходов)
class FpTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      teamResultStep,
      finalStep,
    ],
  );
}

// 3 Командная игра (есть 2 место) с ПО
class WpTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      teamResultStep,
      finalStep,
    ],
  );
}

// 3 Командная игра (есть 2 место) с ПО (есть порядок ходов)
class WpFpTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      teamResultStep,
      finalStep,
    ],
  );
}

// 3 Командная игра (есть 2 место) + раунды
class RoundsTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      teamRoundsStep,
      sessionStopStep,
      scoreInputStep,
      teamResultStep,
      finalStep,
    ],
  );
}

// 3 Командная игра (есть 2 место) + раунды (есть порядок ходов)
class RoundsFpTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      teamRoundsStep,
      sessionStopStep,
      scoreInputStep,
      teamResultStep,
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
class RoundsCoopScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
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
class FpCoopScenario {
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
class RoundsFpCoopScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
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
class RoundsSoloScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      soloResultStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель)
class OneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      sessionStopStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель) (есть порядок ходов)
class FpOneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель) с ПО
class WpOneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель) с ПО (есть порядок ходов)
class WpFpOneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      sessionStopStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель) + раунды
class RoundsOneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      sessionStartStep,
      teamRoundsStep,
      sessionStopStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 6 Командная игра (1 победитель) + раунды (есть порядок ходов)
class RoundsFpOneTeamWinScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      numberTeamsStep,
      teamManagementStep,
      gamersTurnOrderStep,
      sessionStartStep,
      teamRoundsStep,
      sessionStopStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}
