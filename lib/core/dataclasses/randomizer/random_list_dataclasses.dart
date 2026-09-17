import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/randomizer/list_item_dataclasses.dart';

class RandomListData {
  final RandomList randomList;
  final List<ListItemMutableData> items;

  RandomListData({required this.randomList, required this.items});
}

class RandomListMutableData {
  int? id;
  String name;
  int type;
  bool isUnique;
  int itemsNum;
  List<ListItemMutableData> items;

  RandomListMutableData({
    this.id,
    required this.name,
    required this.type,
    required this.isUnique,
    required this.itemsNum,
    required this.items,
  });
}
