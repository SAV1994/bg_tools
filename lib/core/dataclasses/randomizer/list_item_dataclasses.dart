import 'package:bg_tools/core/database/app_database.dart';

class ListItemData {
  final ListItem listItem;
  final GameComponent? component;

  ListItemData({required this.listItem, this.component});
}

class ListItemInputData {
  final GameComponent? component;
  final String? name;
  int copiesNum;

  ListItemInputData({this.component, this.name, required this.copiesNum});

  // Метод для создания копии объекта
  ListItemInputData clone() =>
      ListItemInputData(component: component, name: name, copiesNum: copiesNum);
}
