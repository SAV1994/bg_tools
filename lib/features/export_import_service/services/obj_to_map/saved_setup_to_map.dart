import 'package:bg_tools/core/database/app_database.dart';

Map<String, dynamic> getSavedSetupData(SavedSetup savedSetup) {
  return {
    'id': savedSetup.id,
    'name': savedSetup.name,
    'description': savedSetup.description,
    'randomSetupId': savedSetup.randomSetupId,
  };
}
