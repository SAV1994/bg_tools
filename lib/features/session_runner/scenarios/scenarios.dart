import 'package:bg_tools/features/session_runner/scenarios/steps.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

// 1 Распределение по местам
class ClassicScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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
      sessionStartStopStep,
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

// 7 Тайные роли с ведущим (определяется приложением)
class DistributionMasterSecretRolesScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      secretRoleManagementStep,
      sessionStartStep,
      playerRolesViewStep,
      secretRolesViewStep,
      sessionStopStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 7 Тайные роли (определяется приложением)
class DistributionSecretRolesScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      secretRoleManagementStep,
      sessionStartStep,
      playerRolesViewStep,
      sessionStopStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 7 Тайные роли
class SecretRolesScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      secretRoleManagementStep,
      sessionStartStopStep,
      roleAssignmentStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды
class SecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStopStep,
      teamManagementStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды (есть порядок ходов)
class FpSecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStopStep,
      teamManagementStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды с ПО
class WpSecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStopStep,
      teamManagementStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды с ПО (есть порядок ходов)
class WpFpSecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStopStep,
      teamManagementStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды + раунды
class RoundsSecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      teamManagementStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}

// 8 Скрытые команды + раунды (есть порядок ходов)
class RoundsFpSecretTeamScenario {
  static Scenario get scenario => Scenario(
    steps: [
      rootSessionSelectStep,
      gamersSelectStep,
      gamersTurnOrderStep,
      sessionStartStep,
      roundsStep,
      sessionStopStep,
      teamManagementStep,
      scoreInputStep,
      teamOneWinnerSelectStep,
      finalStep,
    ],
  );
}
