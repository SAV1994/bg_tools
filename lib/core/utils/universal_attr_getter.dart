import 'package:bg_tools/core/database/app_database.dart';

class UniversalAttrGetter {
  static String getTitle(dynamic instance) {
    if (instance is Gamer) {
      return instance.username;
    }

    return instance.name;
  }
}