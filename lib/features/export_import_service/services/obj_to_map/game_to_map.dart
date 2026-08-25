import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getGameData(Game game) {
  return {
    'id': game.id,
    'name': game.name,
    'description': game.description,
    'year': game.year,
    'minPlayers': game.minPlayers,
    'maxPlayers': game.maxPlayers,
    'isInCollection': game.isInCollection,
    'isFavorite': game.isFavorite,
    'rating': game.rating,
    'isStandalone': game.isStandalone,
    'imagePath': game.imagePath,
  };
}
