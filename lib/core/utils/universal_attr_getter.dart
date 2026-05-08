import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/utils/dateformats.dart';

// Геттер для сущностей БД
class UniversalAttrGetter {
  static String getTitle(dynamic instance) {
    if (instance is Gamer) {
      return instance.username;
    } else if (instance is GamingSession) {
      return '''Игровая сессия ${DateFormats.formatDateTime(instance.startedAt)} 
      - ${instance.finishedAt == null ? "..." : DateFormats.formatDateTime(instance.finishedAt!)}''';
    } else if (instance is Note) {
      return instance.title;
    }

    return instance.name;
  }
}
