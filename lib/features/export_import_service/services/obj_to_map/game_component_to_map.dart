import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getGameComponentData(GameComponent gameComponent) {
  return {
    'id': gameComponent.id,
    'name': gameComponent.name,
    'componentTypeId': gameComponent.componentTypeId,
    'imagePath': gameComponent.imagePath,
  };
}
