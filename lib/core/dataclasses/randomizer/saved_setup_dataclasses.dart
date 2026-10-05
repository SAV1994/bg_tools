import 'package:bg_tools/core/database/app_database.dart';

class SavedSetupData {
  final SavedSetup savedSetup;
  final List<SavedListItemData> items;

  SavedSetupData({required this.savedSetup, required this.items});
}

class SavedListItemData {
  final int id;
  final RandomList list;
  final ListItem listItem;
  final GameComponent component;
  final int position;

  SavedListItemData({
    required this.id,
    required this.list,
    required this.listItem,
    required this.component,
    required this.position,
  });
}

class SavedListItemInputData {
  final int listId;
  final int listItemId;
  final int position;

  SavedListItemInputData({
    required this.listId,
    required this.listItemId,
    required this.position,
  });
}
