import 'package:bg_tools/core/consts/app_consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/utils/dateformats.dart';

// Геттер для сущностей БД
class UniversalAttrGetter {
  static String getTitle(dynamic instance) {
    if (instance is Gamer) {
      return instance.username;
    } else if (instance is GamingSession) {
      return 'Игровая сессия от ${DateFormats.formatDate(instance.startedAt)}';
    } else if (instance is Rating) {
      return 'Топ от ${MonthsEnum.fromId(instance.month).label} ${instance.year} г.';
    } else if (instance is Note) {
      return instance.title;
    }

    return instance.name;
  }
}
