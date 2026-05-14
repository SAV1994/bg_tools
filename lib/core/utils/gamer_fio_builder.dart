import 'package:bg_tools/core/database/app_database.dart';

String getGamerFio(Gamer gamer) {
  String fio = '';
  if (gamer.lastName != null) {
    fio += '${gamer.lastName} ';
  }
  fio += '${gamer.firstName} ';
  if (gamer.middleName != null) {
    fio += '${gamer.middleName}';
  }

  return fio;
}
