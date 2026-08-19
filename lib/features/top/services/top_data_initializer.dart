import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/features/top/consts.dart';

class TopDataInitializer {
  int year;
  int month;
  GameDao gameDao;
  int? tagId;
  int? designerId;
  int? artistId;

  int topType = TopTypeEnum.common.id;
  final List<List<int>> pairs = [];
  final Map<String, dynamic> gamesInfo = {};

  TopDataInitializer({
    required this.year,
    required this.month,
    required this.gameDao,
    this.tagId,
    this.designerId,
    this.artistId,
  });

  Future<void> init() async {
    List<Game> games = await gameDao.getAll(
      onlyStandalone: true,
      tagId: tagId,
      designerId: designerId,
      artistId: artistId,
    );

    for (int i = 0; i < games.length; i++) {
      _addGamesInfo(games[i]);
      for (int j = i + 1; j < games.length; j++) {
        pairs.add([games[i].id, games[j].id]);
      }
    }

    pairs.shuffle();
    _setTopType();

    await AppDataManager.saveRatingProcess({
      'topType': topType,
      'tagId': tagId,
      'designerId': designerId,
      'artistId': artistId,
      'year': year,
      'month': month,
      'pairs': pairs,
      'totalPairs': pairs.length,
      'totalGames': games.length,
      'gamesInfo': gamesInfo,
      'data': {},
    });
  }

  void _addGamesInfo(Game game) {
    gamesInfo[game.id.toString()] = {
      'name': game.name,
      'imagePath': game.imagePath,
      'score': 0,
    };
  }

  void _setTopType() {
    if (tagId != null) {
      topType = TopTypeEnum.byTag.id;
    } else if (designerId != null) {
      topType = TopTypeEnum.byDesigner.id;
    } else if (artistId != null) {
      topType = TopTypeEnum.byArtist.id;
    }
  }
}
