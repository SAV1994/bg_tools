import 'package:bg_tools/core/database/app_database.dart';

// Класс для хранения игровой сессии
class GamingSessionData {
  final GamingSession gamingSession;
  final Game game;

  GamingSessionData({required this.gamingSession, required this.game});
}

// Класс для хранения игорока игровой сессии
class GamingSessionGamerData {
  final Gamer gamer;
  final int? score;
  final int? place;
  final int? turnOrder;
  final int? team;
  final Map<String, dynamic>? data;

  GamingSessionGamerData({
    required this.gamer,
    this.score,
    this.place,
    this.turnOrder,
    this.team,
    this.data,
  });
}

// Класс для хранения игровой сессии со всеми связанными сущностями
class GamingSessionFullData {
  final GamingSession gamingSession;
  final Game game;
  final List<Game> expansions;
  final Set<int> selectedExpansionIds;
  final List<GamingSessionGamerData?> gamers;
  final GamingSession? rootSession;
  final List<GamingSession?> sessionParts;
  final List<GamingSession?> linkedSessions;

  GamingSessionFullData({
    required this.gamingSession,
    required this.game,
    required this.expansions,
    required this.selectedExpansionIds,
    required this.gamers,
    this.rootSession,
    required this.sessionParts,
    required this.linkedSessions,
  });
}
