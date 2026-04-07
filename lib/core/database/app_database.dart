import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:bg_tools/core/database/daos/artist_dao.dart';
import 'package:bg_tools/core/database/daos/designer_dao.dart';
import 'package:bg_tools/core/database/daos/game_dao.dart';
import 'package:bg_tools/core/database/daos/tag_dao.dart';
import 'package:bg_tools/core/database/tables/artist.dart';
import 'package:bg_tools/core/database/tables/designer.dart';
import 'package:bg_tools/core/database/tables/game.dart';
import 'package:bg_tools/core/database/tables/gamer.dart';
import 'package:bg_tools/core/database/tables/games_artists.dart';
import 'package:bg_tools/core/database/tables/games_designers.dart';
import 'package:bg_tools/core/database/tables/games_tags.dart';
import 'package:bg_tools/core/database/tables/gaming_session.dart';
import 'package:bg_tools/core/database/tables/gaming_sessions_gamers.dart';
import 'package:bg_tools/core/database/tables/tag.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Artists,
    Designers,
    GamesArtists,
    GamesDesigners,
    GamesTags,
    Games,
    Gamers,
    GamingSessionsGamers,
    GamingSessions,
    Tags,
  ],
  daos: [
    GameDao,
    DesignerDao,
    ArtistDao,
    TagDao,
  ]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // // Миграции (если нужно)
  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onUpgrade: (migrator, from, to) async {
  //       if (from < 2) {
  //         // Логика миграции
  //       }
  //     },
  //   );
  // }
}

QueryExecutor _openConnection() {
  // Для Android/iOS/Desktop
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));
    return NativeDatabase(file);
  });
}