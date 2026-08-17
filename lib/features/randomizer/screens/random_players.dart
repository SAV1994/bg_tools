import 'package:flutter/material.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/features/randomizer/screens/_random_instance.dart';

class RandomPlayersScreen extends RandomInstancesScreen {
  const RandomPlayersScreen({super.key});

  @override
  RandomPlayersScreenState createState() => RandomPlayersScreenState();
}

class RandomPlayersScreenState extends RandomInstancesScreenStateState {
  @override
  Function get buildAddModal =>
      (context, notSelectedData, onSelect) => buildAddPlayerModal(
        context,
        notSelectedData as List<Gamer>,
        onSelect,
      );
  @override
  AdditionalOptionType? get additionalOption => AdditionalOptionType(
    btn: IconButton(
      icon: Icon(gamersIcon),
      onPressed: () => _addSessionGamers(),
    ),
    show: (sData) =>
        sData != null && sData['gamers'].isNotEmpty && selectedData.isEmpty,
  );
  @override
  String get emtyListMsg => 'Выберите игроков';
  @override
  IconData get instIcon => gamersIcon;
  @override
  IconData get singleInstIcon => Icons.person;

  @override
  Future<void> loadData() async {
    final gamerDao = ref.read(gamerDaoProvider);
    allData = await gamerDao.getEverybody();

    final Map<String, dynamic>? randomData =
        await AppDataManager.loadRandomPlayers();
    if (randomData != null) {
      selectedData = randomData['selected'];
      result = randomData['result'];
    }
  }

  @override
  Future<void> saveData() async {
    await AppDataManager.saveRandomPlayers({
      'selected': selectedData,
      'result': result,
    });
  }

  @override
  Future<void> clearAppData() async {
    await AppDataManager.clearRandomPlayers();
  }

  Future<void> _addSessionGamers() async {
    setState(() => isLoading = true);
    setState(() {
      for (Map<String, dynamic> gamerData in sessionData!['gamers']) {
        selectedData.add({
          'id': gamerData['id'],
          'name': gamerData['username'],
        });
      }
      isLoading = false;
    });
  }
}
