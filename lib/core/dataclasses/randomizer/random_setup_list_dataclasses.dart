import 'package:bg_tools/core/dataclasses/randomizer/random_list_dataclasses.dart';

class RandomSetupListMutableData {
  int? id;
  String name;
  bool isUnique;
  int itemsNum;
  RandomListMutableData randomList;

  RandomSetupListMutableData({
    this.id,
    required this.name,
    required this.isUnique,
    required this.itemsNum,
    required this.randomList,
  });
}
