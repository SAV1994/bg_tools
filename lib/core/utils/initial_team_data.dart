void setIniialTeamData(Map teamsData, int teamId) {
  teamsData[teamId.toString()] = {
    'score': null,
    'scoreByrounds': [],
    'numWInRounds': 0,
    'place': null,
    'name': null,
  };
}
