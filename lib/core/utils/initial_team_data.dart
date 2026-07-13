void setIniialTeamData(Map teamsData, int teamId, {String? name}) {
  teamsData[teamId.toString()] = {
    'score': null,
    'scoreByrounds': [],
    'numWInRounds': 0,
    'place': null,
    'name': name,
  };
}
