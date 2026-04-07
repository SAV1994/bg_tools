import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/gaming_session.dart';
import 'package:bg_tools/core/database/tables/gaming_sessions_gamers.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';

part 'gaming_session_dao.g.dart';

@DriftAccessor(tables: [GamingSessions, GamingSessionsGamers])
class GamingSessionDao extends DatabaseAccessor<AppDatabase> with _$GamingSessionDaoMixin {
  GamingSessionDao(super.db);
  
  // Создание новой записи
  Future<int> create(
    GamingSessionsCompanion gamingSession,
    List<GamingSessionGamerData?> gamersData
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
        )
      );
    }

    return gamingSessionId;
  }

  // Редактирование
  Future<bool> updInstance(
    int gamingSessionId, 
    GamingSessionsCompanion gamingSession, 
    List<GamingSessionGamerData?> gamersData
  ) async {
    // 1. Обновляем
    final updateResult = await (update(gamingSessions)..where((g) => g.id.equals(gamingSessionId))).write(gamingSession);
    
    // 2. Удаляем старые связи
    await (delete(gamingSessionsGamers)..where((gg) => gg.gamingSessionId.equals(gamingSessionId))).go();
    
    // 3. Добавляем новые связи
    for (final gamerData in gamersData) {
      await into(gamingSessionsGamers).insert(
        GamingSessionsGamersCompanion(
          gamingSessionId: Value(gamingSessionId),
          gamerId: Value(gamerData!.gamer.id),
          score: Value(gamerData.score),
          place: Value(gamerData.place),
          turnOrder: Value(gamerData.turnOrder),
        )
      );
    }

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int gamingSessionId) async {
    return await (delete(gamingSessions)..where((g) => g.id.equals(gamingSessionId))).go();
  }

  // Все игровые сессии
  Future<List<GamingSession>> getAll() async {
    return await (select(gamingSessions)..orderBy([
      (gamingSession) => OrderingTerm(expression: gamingSession.startedAt, mode: OrderingMode.desc)
    ])).get();
  }

  // Игровая сессия со всеми игроками
  Future<GamingSessionFullData?> getFullInfo(int gamingSessionId) async {
    final gamingSession = await (select(gamingSessions)..where((g) => g.id.equals(gamingSessionId))).getSingleOrNull();

    if (gamingSession == null) return null;

    // Получаем игроков с дополнительной информацией из связующей таблицы
    final query = select(gamers).join([
      innerJoin(gamingSessionsGamers, gamingSessionsGamers.gamerId.equalsExp(gamers.id))
    ])..where(gamingSessionsGamers.gamingSessionId.equals(gamingSessionId));

    final Game? game = await (select(games)..where((g) => g.id.equals(gamingSession.gameId))).getSingleOrNull();
        
    final rows = await query.get();
    final gamersInfo = rows.map((row) {
      final Gamer gamer = row.readTable(gamers);
      final GamingSessionsGamer gamerInfo = row.readTable(gamingSessionsGamers);

      return GamingSessionGamerData(
        gamer: gamer,
        score: gamerInfo.score,
        place: gamerInfo.place,
        turnOrder: gamerInfo.turnOrder,
      );
    }).toList();

    return GamingSessionFullData(
      gamingSession: gamingSession,
      game: game!,
      gamers: gamersInfo,
    );
  }
}
