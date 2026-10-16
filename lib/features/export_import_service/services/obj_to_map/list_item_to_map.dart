import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getListItemData(ListItem listItem) {
  return {
    'id': listItem.id,
    'name': listItem.name,
    'componentId': listItem.componentId,
    'randomListId': listItem.randomListId,
    'copiesNum': listItem.copiesNum,
  };
}
