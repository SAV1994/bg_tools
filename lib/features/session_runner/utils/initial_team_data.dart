void setIniialTeamData(Map teamsData, int teamId, {String? name}) {
  teamsData[teamId.toString()] = {
    'score': null,
    'scoreByrounds': [],
    'numWinRounds': 0,
    'place': null,
    'name': name,
  };
}
