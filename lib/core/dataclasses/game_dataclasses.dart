// Класс для хранения игры со всеми связанными сущностями
import 'package:bg_tools/core/database/app_database.dart';

class GameFullData {
  final Game game;
  final List<Designer> designers;
  final Set<int> selectedDesignerIds;
  final List<Artist> artists;
  final Set<int> selectedArtistIds;
  final List<Tag> tags;
  final Set<int> selectedTagIds;
  final Game? baseGame;
  
  GameFullData({
    required this.game,
    required this.designers,
    required this.selectedDesignerIds,
    required this.artists,
    required this.selectedArtistIds,
    required this.tags,
    required this.selectedTagIds,
    this.baseGame ,
  });
}
