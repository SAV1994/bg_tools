import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getComponentTypeData(ComponentType componentType) {
  return {
    'id': componentType.id,
    'name': componentType.name,
    'gameId': componentType.gameId,
  };
}
