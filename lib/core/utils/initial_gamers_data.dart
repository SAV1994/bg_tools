List<dynamic> cleanGamersData(List<dynamic> gamersData) {
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
      'team': gamerData['team'],
    });
  }

  return claenedGamersData;
}
