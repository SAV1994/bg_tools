import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/randomizer/list_item_dataclasses.dart';

class RandomListData {
  final RandomList randomList;
  final List<ListItemData> items;

  RandomListData({required this.randomList, required this.items});
}
