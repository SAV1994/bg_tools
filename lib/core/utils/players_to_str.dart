import 'package:bg_tools/core/consts/export.dart';

String getPlayersCountStr(int? minPlayers, int? maxPlayers) {
  if (minPlayers == null && maxPlayers == null) {
    return emptyVal;
  }

  String playersCount = '';

  if (maxPlayers == null) {
    playersCount += 'от $minPlayers ';
    if (minPlayers == 1) {
      playersCount += 'игрока';
    } else {
      playersCount += 'игроков';
    }
    return playersCount;
  }

  if (minPlayers == null) {
    playersCount += 'до $maxPlayers ';
    if (maxPlayers == 1) {
      playersCount += 'игрока';
    } else {
      playersCount += 'игроков';
    }
    return playersCount;
  }

  if (minPlayers == maxPlayers) {
    playersCount = minPlayers.toString();

    switch (minPlayers) {
      case 1:
        playersCount += ' игрок';
      case 2:
        playersCount += ' игрока';
      case 3:
        playersCount += ' игрока';
      case 4:
        playersCount += ' игрока';
      default:
        playersCount += ' игроков';
    }
    return playersCount;
  }

  return '$minPlayers-$maxPlayers игроков';
}
