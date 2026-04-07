import 'package:bg_tools/core/database/app_database.dart';

// Геттер для сущностей БД
class UniversalAttrGetter {
  static String getTitle(dynamic instance) {
    if (instance is Gamer) {
      return instance.username;
    } else if (instance is GamingSession) {
      return 'Игровую сессию ${instance.startedAt} - ${instance.finishedAt ?? "..."}';
    }

    return instance.name;
  }
}
