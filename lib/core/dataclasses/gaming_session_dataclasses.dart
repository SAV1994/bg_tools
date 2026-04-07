import 'package:bg_tools/core/database/app_database.dart';

class GamingSessionGamerData {
  final Gamer gamer;
  final int? score;
  final int? place;
  final int? turnOrder;
  
  GamingSessionGamerData({
    required this.gamer,
    this.score,
    this.place,
    this.turnOrder,
  });
}

class GamingSessionFullData {
  final GamingSession gamingSession;
  final Game game;
  final List<GamingSessionGamerData?> gamers;
  
  GamingSessionFullData({
    required this.gamingSession,
    required this.game,
    required this.gamers,
  });
}
