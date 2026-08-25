import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/features/top/dataclasses.dart';

abstract class BaseRankingHandler {
  int initialSteps = 0;
  int totalSteps = 0;

  Future<List<GameItem>> getCurrentPair();

  Future<void> saveSelection(GameItem selected);

  Future<void> finishRanking(WidgetRef ref);
}
