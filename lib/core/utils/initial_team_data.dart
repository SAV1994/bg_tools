import 'package:bg_tools/core/consts.dart';

void setIniialTeamData(Map<String, dynamic> teamsData, TeamsEnum team) {
  teamsData[team.id.toString()] = {
    'score': null,
    'scoreByrounds': [],
    'numWInRounds': 0,
    'place': null,
  };
}
