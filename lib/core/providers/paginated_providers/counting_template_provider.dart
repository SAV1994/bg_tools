import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';

final countingTemplatesPaginatedProvider =
    AsyncNotifierProvider<CountingTemplatesNotifier, List<dynamic>>(() {
      return CountingTemplatesNotifier();
    });

class CountingTemplatesNotifier extends BaseNotifier {
  int? gameTypeId;
  int? firstPlayerStartTypeId;
  int? resultTypeId;
  int? generalDefeatTypeId;
  int? teamPointTypeId;
  int? pointTypeId;
  int? roundsTypeId;
  int? altVictoryTypeId;
  int? firstPlayerRoundTypeId;
  int? frstPlayerRoundPointTypeId;
  int? sequencePlayersMovesTypeId;
  int? gameHostTypeId;
  int? secretRolesDistributionTypeId;
  int? uniquenessRolesTypeId;

  @override
  Future<List<dynamic>> load() async {
    final dao = ref.read(countingTemplateDaoProvider);

    totalItems = await dao.getTotalCount(
      gameTypeId: gameTypeId,
      firstPlayerStartTypeId: firstPlayerStartTypeId,
      resultTypeId: resultTypeId,
      generalDefeatTypeId: generalDefeatTypeId,
      teamPointTypeId: teamPointTypeId,
      pointTypeId: pointTypeId,
      roundsTypeId: roundsTypeId,
      altVictoryTypeId: altVictoryTypeId,
      firstPlayerRoundTypeId: firstPlayerRoundTypeId,
      frstPlayerRoundPointTypeId: frstPlayerRoundPointTypeId,
      sequencePlayersMovesTypeId: sequencePlayersMovesTypeId,
      gameHostTypeId: gameHostTypeId,
      secretRolesDistributionTypeId: secretRolesDistributionTypeId,
      uniquenessRolesTypeId: uniquenessRolesTypeId,
      searchQuery: searchQuery,
    );

    return await dao.getPaginated(
      page: page,
      pageSize: pageSize,
      reverseOrdering: reverseOrdering,
      gameTypeId: gameTypeId,
      firstPlayerStartTypeId: firstPlayerStartTypeId,
      resultTypeId: resultTypeId,
      generalDefeatTypeId: generalDefeatTypeId,
      teamPointTypeId: teamPointTypeId,
      pointTypeId: pointTypeId,
      roundsTypeId: roundsTypeId,
      altVictoryTypeId: altVictoryTypeId,
      firstPlayerRoundTypeId: firstPlayerRoundTypeId,
      frstPlayerRoundPointTypeId: frstPlayerRoundPointTypeId,
      sequencePlayersMovesTypeId: sequencePlayersMovesTypeId,
      gameHostTypeId: gameHostTypeId,
      secretRolesDistributionTypeId: secretRolesDistributionTypeId,
      uniquenessRolesTypeId: uniquenessRolesTypeId,
      searchQuery: searchQuery,
    );
  }

  Future<void> filterByGameType(int? id) async {
    gameTypeId = id;
    page = 0;
    state = await AsyncValue.guard(() => load());
  }

  @override
  void resetAdditionalParams() async {
    gameTypeId = null;
    firstPlayerStartTypeId = null;
    resultTypeId = null;
    generalDefeatTypeId = null;
    teamPointTypeId = null;
    pointTypeId = null;
    roundsTypeId = null;
    altVictoryTypeId = null;
    firstPlayerRoundTypeId = null;
    frstPlayerRoundPointTypeId = null;
    sequencePlayersMovesTypeId = null;
    gameHostTypeId = null;
    secretRolesDistributionTypeId = null;
    uniquenessRolesTypeId = null;
  }

  int countActiveFilters() {
    int counter = 0;

    if (gameTypeId != null) {
      counter += 1;
    }
    if (firstPlayerStartTypeId != null) {
      counter += 1;
    }
    if (resultTypeId != null) {
      counter += 1;
    }
    if (generalDefeatTypeId != null) {
      counter += 1;
    }
    if (teamPointTypeId != null) {
      counter += 1;
    }
    if (pointTypeId != null) {
      counter += 1;
    }
    if (roundsTypeId != null) {
      counter += 1;
    }
    if (altVictoryTypeId != null) {
      counter += 1;
    }
    if (firstPlayerRoundTypeId != null) {
      counter += 1;
    }
    if (frstPlayerRoundPointTypeId != null) {
      counter += 1;
    }
    if (sequencePlayersMovesTypeId != null) {
      counter += 1;
    }
    if (gameHostTypeId != null) {
      counter += 1;
    }
    if (secretRolesDistributionTypeId != null) {
      counter += 1;
    }
    if (uniquenessRolesTypeId != null) {
      counter += 1;
    }

    return counter;
  }
}
