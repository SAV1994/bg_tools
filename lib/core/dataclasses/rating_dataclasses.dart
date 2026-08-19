import 'package:bg_tools/core/database/app_database.dart';

// Класс для хранения рейтинга
class RatingData {
  final Rating rating;
  final Tag? tag;
  final Designer? designer;
  final Artist? artist;
  final Map<String, dynamic>? data;

  RatingData({
    required this.rating,
    this.tag,
    this.designer,
    this.artist,
    this.data,
  });
}

// Класс для хранения данных игры ТОПа
class RatingGamePreSaveData {
  final int gameId;
  final double score;
  final int place;

  RatingGamePreSaveData({
    required this.gameId,
    required this.score,
    required this.place,
  });
}

// Класс для хранения игры ТОПа
class RatingGameData {
  final Game game;
  final double score;
  final int place;

  RatingGameData({
    required this.game,
    required this.score,
    required this.place,
  });
}

// Класс для хранения рейтинга со всеми связанными играми
class RatingFullData {
  final Rating rating;
  final List<RatingGameData?> games;
  final Tag? tag;
  final Designer? designer;
  final Artist? artist;
  final Map<String, dynamic>? data;

  RatingFullData({
    required this.rating,
    required this.games,
    this.tag,
    this.designer,
    this.artist,
    this.data,
  });
}
