// Маппинг сценариев
import 'package:bg_tools/features/session_runner/scenarios/scenarios.dart';

final Map<String, dynamic> scenarioMapping = {
  // Распределение по местам
  '1.1.1': WpFpClassicScenario.scenario,
  '1.1.2': RoundsFpClassicScenario.scenario,
  '1.1.3': FpClassicScenario.scenario,
  '1.2.1': WpClassicScenario.scenario,
  '1.2.2': RoundsClassicScenario.scenario,
  '1.2.3': ClassicScenario.scenario,
  // Один победитель
  '2.1.1': WpFpClassicScenario.scenario,
  '2.1.2': RoundsFpClassicScenario.scenario,
  '2.1.3': FpOneWinnerScenario.scenario,
  '2.2.1': WpClassicScenario.scenario,
  '2.2.2': RoundsClassicScenario.scenario,
  '2.2.3': OneWinnerScenario.scenario,
  // Командная игра (есть 2 место)
  '3.1.1': WpFpTeamScenario.scenario,
  '3.1.2': RoundsFpTeamScenario.scenario,
  '3.1.3': FpTeamScenario.scenario,
  '3.2.1': WpTeamScenario.scenario,
  '3.2.2': RoundsTeamScenario.scenario,
  '3.2.3': TeamScenario.scenario,
  // Кооператив
  '4.1.1': FpCoopScenario.scenario,
  '4.1.2': RoundsFpCoopScenario.scenario,
  '4.1.3': FpCoopScenario.scenario,
  '4.2.1': CoopScenario.scenario,
  '4.2.2': RoundsCoopScenario.scenario,
  '4.2.3': CoopScenario.scenario,
  // Соло
  '5.0.1': SoloScenario.scenario,
  '5.0.2': RoundsSoloScenario.scenario,
  '5.0.3': SoloScenario.scenario,
  // Командная игра (1 победитель)
  '6.1.1': WpFpOneTeamWinScenario.scenario,
  '6.1.2': RoundsFpOneTeamWinScenario.scenario,
  '6.1.3': FpOneTeamWinScenario.scenario,
  '6.2.1': WpOneTeamWinScenario.scenario,
  '6.2.2': RoundsOneTeamWinScenario.scenario,
  '6.2.3': OneTeamWinScenario.scenario,
  // Тайные роли
  '7.0.0': SoloScenario.scenario,
};
