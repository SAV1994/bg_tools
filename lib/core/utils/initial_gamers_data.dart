List<dynamic> cleanGamersData(
  List<dynamic> gamersData, {
  bool saveTeam = false,
}) {
  final List<dynamic> claenedGamersData = [];
  for (final Map<String, dynamic> gamerData in gamersData) {
    claenedGamersData.add({
      'id': gamerData['id'],
      'username': gamerData['username'],
      'fio': gamerData['fio'],
      'score': null,
      'scoreByrounds': [],
      'numWInRounds': 0,
      'place': null,
      'turnOrder': null,
      'team': saveTeam ? gamerData['team'] : null,
      'role': {},
    });
  }

  return claenedGamersData;
}
