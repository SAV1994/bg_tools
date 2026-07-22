import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as ffi;

import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/database/tables/export.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Artists,
    CountingTemplates,
    Designers,
    ExpansionsGames,
    GamesArtists,
    GamesCountingTemplatesExpansions,
    GamesCountingTemplates,
    GamesDesigners,
    GamesTags,
    Games,
    Gamers,
    GamingSessionsExpansions,
    GamingSessionsGamers,
    GamingSessions,
    Notes,
    Ratings,
    RatingsGames,
    Tags,
  ],
  daos: [
    ArtistDao,
    CountingTemplateDao,
    DesignerDao,
    GameDao,
    GamerDao,
    GamesCountingTemplatesDao,
    GamingSessionDao,
    NoteDao,
    TagDao,
  ],
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

        /// Индексы
        // Художники
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_artists_name_ci ON artists (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_artists_name_lower ON artists (lower_unicode(name));',
        );
        //  Шаблоны подсчёта
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_counting_templates_name_ci ON counting_templates (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_counting_templates_name_lower ON counting_templates (lower_unicode(name));',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_counting_templates_description_lower ON counting_templates (lower_unicode(description));',
        );
        // Геймдизайнеры
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_designers_name_ci ON designers (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_designers_name_lower ON designers (lower_unicode(name));',
        );
        // Игры
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_games_name_ci ON games (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_games_name_lower ON games (lower_unicode(name));',
        );
        // Игроки
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_gamers_username_ci ON gamers (username COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_gamers_username_lower ON gamers (lower_unicode(username));',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_gamers_first_name_lower ON gamers (lower_unicode(first_name));',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_gamers_last_name_lower ON gamers (lower_unicode(last_name));',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_gamers_middle_name_lower ON gamers (lower_unicode(middle_name));',
        );
        // Шаблоны подсчёта игры
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_games_counting_templates_name_ci ON games_counting_templates (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_games_counting_templates_name_lower ON games_counting_templates (lower_unicode(name));',
        );
        // Заметки
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_notes_title_ci ON notes (title COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_notes_title_lower ON notes (lower_unicode(title));',
        );
        // Тэги
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_tags_name_ci ON tags (name COLLATE UNICODE_CI);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_tags_name_lower ON tags (lower_unicode(name));',
        );

        await _addInitialData();
      },
      beforeOpen: (details) async {
        // Включаем поддержку внешних ключей для обеспечения целостности данных
        await customStatement('PRAGMA foreign_keys = ON');
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
      GamersCompanion.insert(
        username: 'Игрок',
        firstName: 'Игрок',
        isOwner: Value(true),
      ),
    );
  }
}

QueryExecutor _openConnection() {
  // Для Android/iOS/Desktop
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        // 1. Регистрируем lower
        rawDb.createFunction(
          functionName:
              'lower_unicode', // даем уникальное имя, чтобы не конфликтовать со встроенным lower
          argumentCount: ffi.AllowedArgumentCount(1),
          function: (args) => args.first is String
              ? (args.first as String).toLowerCase()
              : args.first,
          deterministic: true,
          directOnly: false,
        );

        // 2. Регистрируем правило сортировки (Collation)
        rawDb.createCollation(
          name: 'UNICODE_CI',
          function: (a, b) => a!.toLowerCase().compareTo(b!.toLowerCase()),
        );
      },
    );
  });
}
