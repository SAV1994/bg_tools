import 'package:bg_tools/features/session_runner/utils/export.dart';

void distributeSecretRoles(Map<String, dynamic> sessionData) {
  final List<Map<String, dynamic>> requiredRoles = [];
  final List<Map<String, dynamic>> roles = [];

  for (final role in sessionData['secretRoles']) {
    if (role['isRequired']) {
      requiredRoles.add(role);
    } else {
      roles.add(role);
    }
  }
  requiredRoles.shuffle();
  roles.shuffle();

  final List<Map<String, dynamic>> players = List<Map<String, dynamic>>.from(
    sessionData['gamers'],
  );
  players.shuffle();

  for (final player in players) {
    if (sessionData['master'] != null &&
        sessionData['master'] == player['id']) {
      continue;
    }
    late final Map<String, dynamic> role;
    if (requiredRoles.isNotEmpty) {
      role = requiredRoles.removeLast();
    } else {
      role = roles.removeLast();
    }

    player['team'] = role['teamId'];
    player['role'] = {
      'teamName': role['teamName'],
      'groupName': role['groupName'],
      'roleName': role['roleName'],
      'description': role['description'],
    };

    if (sessionData['teamsData'][role['teamId'].toString()] == null) {
      setIniialTeamData(sessionData['teamsData'], role['teamId']);
      sessionData['teamsData'][role['teamId'].toString()]['name'] =
          role['teamName'];
    }
  }

  sessionData['numberTeams'] = sessionData['teamsData'].length;
}
