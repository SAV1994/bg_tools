import 'package:bg_tools/core/dataclasses/randomizer/random_setup_list_dataclasses.dart';

class RandomSetupMutableData {
  int? id;
  String name;
  int gameId;
  List<RandomSetupListMutableData> randomSetupLists;

  RandomSetupMutableData({
    this.id,
    required this.name,
    required this.gameId,
    required this.randomSetupLists,
  });
}
