import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/randomizer/random_list_dataclasses.dart';

class RandomSetupData {
  final RandomSetup randomSetup;
  final List<RandomListData> randomLists;

  RandomSetupData({required this.randomSetup, required this.randomLists});
}
