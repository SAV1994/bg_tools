import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/utils/gamer_fio_builder.dart';

Map<String, dynamic> getGamerData(Gamer gamer, int? team) {
  return {
    'id': gamer.id,
    'username': gamer.username,
    'fio': getGamerFio(gamer),
    'score': null,
    'scoreByrounds': [],
    'place': null,
    'turnOrder': null,
    'team': team,
  };
}
