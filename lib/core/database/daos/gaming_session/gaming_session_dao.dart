import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/gaming_session.dart';
import 'package:bg_tools/core/database/tables/gaming_sessions_expansions.dart';
import 'package:bg_tools/core/database/tables/gaming_sessions_gamers.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';

part 'gaming_session_dao.g.dart';

@DriftAccessor(
  tables: [GamingSessions, GamingSessionsGamers, GamingSessionsExpansions],
)
class GamingSessionDao extends DatabaseAccessor<AppDatabase>
    with _$GamingSessionDaoMixin {
  GamingSessionDao(super.db);

  // Создание новой записи
  Future<int> create(
    GamingSessionsCompanion gamingSession,
    List<GamingSessionGamerData?> gamersData,
    Set<int> expansionIds,
  ) async {
    int gamingSessionId = await into(gamingSessions).insert(gamingSession);

    for (final gamerData in gamersData) {
      await into(gamingSessionsGamers).insert(
        GamingSessionsGamersCompanion(
          gamingSessionId: Value(gamingSessionId),
          gamerId: Value(gamerData!.gamer.id),
          score: Value(gamerData.score),
          place: Value(gamerData.place),
          turnOrder: Value(gamerData.turnOrder),
          team: Value(gamerData.team),
          data: Value(
            (gamerData.data != null) ? jsonEncode(gamerData.data) : null,
          ),
        ),
      );
    }

    for (final expansionId in expansionIds) {
      await into(gamingSessionsExpansions).insert(
        GamingSessionsExpansionsCompanion(
          gamingSessionId: Value(gamingSessionId),
          gameId: Value(expansionId),
        ),
      );
    }

    return gamingSessionId;
  }

  // Редактирование
  Future<bool> updInstance(
    int gamingSessionId,
    GamingSessionsCompanion gamingSession,
    List<GamingSessionGamerData?> gamersData,
    Set<int> expansionIds,
  ) async {
    // 1. Обновляем
    final updateResult = await (update(
      gamingSessions,
    )..where((g) => g.id.equals(gamingSessionId))).write(gamingSession);

    // 2. Удаляем старые связи
    await (delete(
      gamingSessionsGamers,
    )..where((gg) => gg.gamingSessionId.equals(gamingSessionId))).go();
    await (delete(
      gamingSessionsExpansions,
    )..where((ge) => ge.gamingSessionId.equals(gamingSessionId))).go();
    // 3. Добавляем новые связи
    for (final gamerData in gamersData) {
      await into(gamingSessionsGamers).insert(
        GamingSessionsGamersCompanion(
          gamingSessionId: Value(gamingSessionId),
          gamerId: Value(gamerData!.gamer.id),
          score: Value(gamerData.score),
          place: Value(gamerData.place),
          turnOrder: Value(gamerData.turnOrder),
          team: Value(gamerData.team),
        ),
      );
    }

    for (final expansionId in expansionIds) {
      await into(gamingSessionsExpansions).insert(
        GamingSessionsExpansionsCompanion(
          gamingSessionId: Value(gamingSessionId),
          gameId: Value(expansionId),
        ),
      );
    }

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int gamingSessionId) async {
    return await (delete(
      gamingSessions,
    )..where((g) => g.id.equals(gamingSessionId))).go();
  }

  JoinedSelectStatement<HasResultSet, dynamic> _getQuery() {
    return (select(gamingSessions).join([
      innerJoin(games, games.id.equalsExp(gamingSessions.gameId)),
    ])..orderBy([
      OrderingTerm(
        expression: gamingSessions.startedAt,
        mode: OrderingMode.desc,
      ),
    ]));
  }

  // Все игровые сессии
  Future<List<GamingSessionData>> getAll() async {
    final query = _getQuery();

    final rows = await query.get();
    return rows.map((row) {
      final Game game = row.readTable(games);
      final GamingSession gamingSession = row.readTable(gamingSessions);

      return GamingSessionData(gamingSession: gamingSession, game: game);
    }).toList();
  }

  // Все игровые сессии (поток)
  Stream<List<GamingSessionData>> watchAll() {
    final query = _getQuery();
    return query.watch().map((rows) {
      return rows.map((row) {
        final Game game = row.readTable(games);
        final GamingSession gamingSession = row.readTable(gamingSessions);

        return GamingSessionData(gamingSession: gamingSession, game: game);
      }).toList();
    });
  }

  // Дополнения, использованные в игровой сессии
  Future<List<Game>> getExpansions(int gamingSessionId) async {
    final query = select(games).join([
      innerJoin(
        gamingSessionsExpansions,
        gamingSessionsExpansions.gameId.equalsExp(games.id),
      ),
    ])..where(gamingSessionsExpansions.gamingSessionId.equals(gamingSessionId));

    final results = await query.get();
    return results.map((row) => row.readTable(games)).toList();
  }

  // Игровая сессия
  Future<GamingSession?> getSingle(int gamingSessionId) async {
    return await (select(
      gamingSessions,
    )..where((g) => g.id.equals(gamingSessionId))).getSingleOrNull();
  }

  // Игровая сессия со всеми игроками
  Future<GamingSessionFullData?> getFullInfo(int gamingSessionId) async {
    final gamingSession = await getSingle(gamingSessionId);

    if (gamingSession == null) return null;

    // Получаем игроков с дополнительной информацией из связующей таблицы
    final query = select(gamers).join([
      innerJoin(
        gamingSessionsGamers,
        gamingSessionsGamers.gamerId.equalsExp(gamers.id),
      ),
    ])..where(gamingSessionsGamers.gamingSessionId.equals(gamingSessionId));

    final Game? game = await (select(
      games,
    )..where((g) => g.id.equals(gamingSession.gameId))).getSingleOrNull();

    final rows = await query.get();
    final gamersInfo = rows.map((row) {
      final Gamer gamer = row.readTable(gamers);
      final GamingSessionsGamer gamerInfo = row.readTable(gamingSessionsGamers);

      return GamingSessionGamerData(
        gamer: gamer,
        score: gamerInfo.score,
        place: gamerInfo.place,
        turnOrder: gamerInfo.turnOrder,
        team: gamerInfo.team,
        data: (gamerInfo.data != null) ? jsonDecode(gamerInfo.data!) : null,
      );
    }).toList();

    final expansions = await getExpansions(gamingSessionId);
    final selectedExpansionIds = expansions.map((g) => g.id).toSet();

    return GamingSessionFullData(
      gamingSession: gamingSession,
      game: game!,
      expansions: expansions,
      selectedExpansionIds: selectedExpansionIds,
      gamers: gamersInfo,
    );
  }

  // Все корневые сессии по игре
  Future<List<GamingSession>> getByGame(int gameId) async {
    final sessions =
        await (select(gamingSessions)..where(
              (gs) => gs.gameId.equals(gameId) & gs.rootSessionId.isNull(),
            ))
            .get();

    return sessions.toList();
  }
}
