import 'package:flutter/material.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/features/randomizer/screens/_random_instance_screen.dart';

class RandomGamesScreen extends RandomInstancesScreen {
  const RandomGamesScreen({super.key});

  @override
  RandomGamesScreenState createState() => RandomGamesScreenState();
}

class RandomGamesScreenState extends RandomInstancesScreenStateState {
  @override
  Function get buildAddModal =>
      (context, notSelectedData, onSelect) =>
          buildAddGameModal(context, notSelectedData as List<Game>, onSelect);
  @override
  AdditionalOptionType? get additionalOption => null;
  @override
  String get emtyListMsg => 'Выберите игры';
  @override
  IconData get instIcon => gamesIcon;
  @override
  IconData get singleInstIcon => Icons.insert_photo;

  @override
  Future<void> loadData() async {
    final gamerDao = ref.read(gameDaoProvider);
    allData = await gamerDao.getStandalones();

    final Map<String, dynamic>? randomData =
        await AppDataManager.loadRandomGames();
    if (randomData != null) {
      selectedData = randomData['selected'];
      result = randomData['result'];
    }
  }

  @override
  Future<void> saveData() async {
    await AppDataManager.saveRandomGames({
      'selected': selectedData,
      'result': result,
    });
  }

  @override
  Future<void> clearAppData() async {
    await AppDataManager.clearRandomGames();
  }
}
