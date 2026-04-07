import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:bg_tools/core/database/daos/daos_exports.dart';
import 'package:bg_tools/core/database/tables/tables_export.dart';

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
    GamerDao,
    GameDao,
    DesignerDao,
    ArtistDao,
    TagDao,
    GamingSessionDao,
  ]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Миграции
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _addInitialData();
      },
      
      // onUpgrade: (migrator, from, to) async {
      //   if (from < 2) {
      //     // Логика миграции
      //   }
      // },
    );
  }

  Future<void> _addInitialData() async {
    await into(gamers).insert(
      GamersCompanion.insert(username: 'Игрок', firstName: 'Игрок', isOwner: Value(true)),
    );
  }
  
}

QueryExecutor _openConnection() {
  // Для Android/iOS/Desktop
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));
    return NativeDatabase(file);
  });
}