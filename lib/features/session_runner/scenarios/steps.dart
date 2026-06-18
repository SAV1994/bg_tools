import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/utils/initial_gamers_data.dart';
import 'package:bg_tools/core/utils/initial_team_data.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';
import 'package:bg_tools/features/session_runner/screens/export.dart';
import 'package:bg_tools/features/session_runner/utils/secret_roles_randomizer.dart';

final rootSessionSelectStep = ScenarioStep(
  title: 'Базовые параметры сессиии',
  description:
      'Вы можете выбрать записанную ранее сессию для сохранения связи между серией игровых сессий. Может быть актуально для игр-компаний. Выбирайте имеено первую сессию серии.',
  contentBuilder: (data) => FirstScreen(data: data),
  validator: (data) {
    if (data['roundsType'] == RoundsTypeEnum.fix.id &&
        (data['totalRounds'] == null || data['totalRounds'] < 1)) {
      throw Exception('Укажите количество раундов');
    } else if ([
      RoundsTypeEnum.dynamic.id,
      RoundsTypeEnum.condition.id,
    ].contains(data['roundsType'])) {
      data['totalRounds'] = infNumRounds;
    }

    if (data['gameHostType'] == GameHostTypeEnum.master.id &&
        data['master'] == null) {
      throw Exception('Укажите ведущего');
    }
  },
);

final numberTeamsStep = ScenarioStep(
  title: 'Количество команд',
  description: 'Укажите количество команд',
  contentBuilder: (data) => NumberTeamsScreen(data: data),
  validator: (data) {
    if (data['numberTeams'] == null) {
      throw Exception('Укажите количкство команд');
    }
  },
);

final teamManagementStep = ScenarioStep(
  title: 'Определение команд',
  description: 'Распределите игроков между командами',
  contentBuilder: (data) => TeamManagementScreen(data: data),
  validator: (data) {
    if (data['gamers'].isEmpty) {
      throw Exception('Добавте игроков');
    }

    Set<int> teamIds = {};
    for (final Map<String, dynamic> gamerData in data['gamers']) {
      teamIds.add(gamerData['team']);
    }
    if (data['numberTeams'] - teamIds.length > 0) {
      throw Exception('Не все команды заполненны');
    }

    final List<dynamic> claenedGamersData = cleanGamersData(
      data['gamers'],
      saveTeam: true,
    );
    AppDataManager.saveLastSessionTeams(claenedGamersData);
  },
);

final gamersSelectStep = ScenarioStep(
  title: 'Игроки',
  description: 'Выбирать игроков лучше в том же порядке, как они сидят',
  contentBuilder: (data) => GamersSelectScreen(data: data),
  validator: (data) {
    if (data['gamers'].isEmpty) {
      throw Exception('Добавте игроков');
    }

    final List<dynamic> claenedGamersData = cleanGamersData(data['gamers']);
    AppDataManager.saveLastSessionGamers(claenedGamersData);
  },
);

final gamersTurnOrderStep = ScenarioStep(
  title: 'Порядок хода',
  description: 'Определие порядок вручную или воспользуйтесь рандомайзером',
  contentBuilder: (data) => GamersTurnOrderScreen(data: data),
  validator: (data) {},
);

final sessionStartStep = ScenarioStep(
  title: 'Запуск сессии',
  description: 'Установка времени начала сессии',
  contentBuilder: (data) => SessionStartScreen(data: data),
  validator: (data) {
    if (data['startedAt'] == null) {
      throw Exception('Запустите сессию');
    }
  },
);

final roundsStep = ScenarioStep(
  title: 'Подсчёт между раундами',
  description: 'Заполните результаты',
  contentBuilder: (data) => ScoreRoundScreen(data: data),
  validator: (data) {
    if (data['roundsType'] == RoundsTypeEnum.fix.id) {
      if (data['round'] != data['totalRounds']) {
        throw Exception('Нужно завершить все раунды');
      }
    } else if (data['roundsType'] == RoundsTypeEnum.condition.id) {
      final int roundsScoreLimit = data['roundsScoreLimit'];
      if (data['teamPointType'] == TeamPointTypeEnum.general.id) {
        final int? generalScore =
            data['teamsData'][TeamsEnum.red.id.toString()]['score'];
        if (generalScore == null ||
            (roundsScoreLimit < 0 && generalScore > roundsScoreLimit ||
                roundsScoreLimit >= 0 && generalScore < roundsScoreLimit)) {
          throw Exception('Не выполнено граничное условие');
        }
      } else {
        bool isFinished = false;
        for (final Map<String, dynamic> gamerData in data['gamers']) {
          if (isFinished == false && gamerData['score'] != null) {
            isFinished =
                roundsScoreLimit < 0 &&
                    gamerData['score'] <= roundsScoreLimit ||
                roundsScoreLimit >= 0 && gamerData['score'] >= roundsScoreLimit;
          }
        }

        if (!isFinished) {
          throw Exception('Не выполнено граничное условие');
        }
      }
    }
  },
);

final teamRoundsStep = ScenarioStep(
  title: 'Подсчёт между раундами',
  description: 'Заполните результаты',
  contentBuilder: (data) => TeamScoreRoundScreen(data: data),
  validator: (data) {
    if (data['roundsType'] == RoundsTypeEnum.fix.id) {
      if (data['round'] != data['totalRounds']) {
        throw Exception('Нужно завершить все раунды');
      }
    } else if (data['roundsType'] == RoundsTypeEnum.condition.id) {
      final int roundsScoreLimit = data['roundsScoreLimit'];
      if (data['teamPointType'] == TeamPointTypeEnum.general.id) {
        bool isFinished = false;
        for (final Map<String, dynamic> teamData in data['teamsData'].values) {
          if (isFinished == false) {
            isFinished =
                roundsScoreLimit < 0 &&
                    teamData['score'] != null &&
                    teamData['score'] <= roundsScoreLimit ||
                roundsScoreLimit >= 0 && teamData['score'] >= roundsScoreLimit;
          }
        }
      } else {
        bool isFinished = false;
        for (final Map<String, dynamic> gamerData in data['gamers']) {
          if (isFinished == false && gamerData['score'] != null) {
            isFinished =
                roundsScoreLimit < 0 &&
                    gamerData['score'] <= roundsScoreLimit ||
                roundsScoreLimit >= 0 && gamerData['score'] >= roundsScoreLimit;
          }
        }

        if (!isFinished) {
          throw Exception('Не выполнено граничное условие');
        }
      }
    }
  },
);

final sessionStopStep = ScenarioStep(
  title: 'Конец сессии',
  description: 'Установка времени конца сессии',
  contentBuilder: (data) => SessionStopScreen(data: data),
  validator: (data) {
    if (data['finishedAt'] == null) {
      throw Exception('Остановите сессию');
    }
  },
);

final oneWinnerSelectStep = ScenarioStep(
  title: 'Выбор победителя',
  description: 'Выберите победителя',
  contentBuilder: (data) => OneWinnerSelectScreen(data: data),
  validator: (data) {
    final Map<String, dynamic>? winner = data['gamers'].firstWhere(
      (gameData) => gameData['place'] == 1,
      orElse: () => null,
    );
    if (winner == null) {
      throw Exception('Выберите победителя');
    }
  },
);

final teamOneWinnerSelectStep = ScenarioStep(
  title: 'Выбор победителя',
  description: 'Выберите победителя',
  contentBuilder: (data) => TeamOneWinnerSelectScreen(data: data),
  validator: (data) {
    bool isSelected = false;
    for (final Map<String, dynamic> teamData in data['teamsData'].values) {
      if (teamData['place'] == 1) {
        isSelected = true;
        break;
      }
    }

    if (!isSelected) {
      throw Exception('Выберите победителя');
    }
  },
);

final soloResultStep = ScenarioStep(
  title: 'Результаты',
  description: 'Отметьте результаты партии',
  contentBuilder: (data) => SoloResultScreen(data: data),
  validator: (data) {},
);

final coopResultStep = ScenarioStep(
  title: 'Результаты',
  description: 'Отметьте результаты партии',
  contentBuilder: (data) => CoopResultScreen(data: data),
  validator: (data) {},
);

final teamResultStep = ScenarioStep(
  title: 'Результаты',
  description: 'Отметьте результаты партии',
  contentBuilder: (data) => TeamResultScreen(data: data),
  validator: (data) {},
);

final scoreInputStep = ScenarioStep(
  title: 'Ввод результатов партии',
  description: 'Отметьте результаты партии',
  contentBuilder: (data) => ScoreInputScreen(data: data),
  validator: (data) {
    if (data['teamPointType'] == TeamPointTypeEnum.general.id) {
      for (int i = 1; i <= data['numberTeams']; i++) {
        if (data['teamsData'][i.toString()]?['score'] == null) {
          throw Exception('Отметьте результаты каждой команды');
        }
      }
    } else {
      for (final Map<String, dynamic> gamerData in data['gamers']) {
        if (gamerData['score'] == null) {
          throw Exception('Отметьте результаты каждого игрока');
        }
      }
    }
  },
);

final resultStep = ScenarioStep(
  title: 'Результаты',
  description:
      'Итоги партии. Если в игре есть возможность альтернативной победы - определите места.',
  contentBuilder: (data) => ResultScreen(data: data),
  validator: (data) {},
);

final secretRoleManagementStep = ScenarioStep(
  title: 'Набор ролей',
  description: 'Выберети роли, которые будут участвовать в партии',
  contentBuilder: (data) => SecretRolesManagementScreen(data: data),
  validator: (data) {
    int playersCount = data['gamers'].length;
    if (data['master'] != null) {
      playersCount--;
    }

    if (data['secretRoles'].length < playersCount) {
      throw Exception(
        'Количество ролей не может быть меньше количества игроков.',
      );
    }

    if (data['secretRoles'].where((role) => role['isRequired'] == true).length >
        playersCount) {
      throw Exception(
        'Количество обязательных ролей не может быть больше количества игроков.',
      );
    }

    if (data['secretRolesDistributionType'] ==
        SecretRolesDistributionTypeEnum.auto.id) {
      distributeSecretRoles(data);
    }
  },
);

final playerRolesViewStep = ScenarioStep(
  title: 'Ознакомление с ролью',
  description: 'Посмотри и запомни роль, затем передай следующему игроку',
  contentBuilder: (data) =>
      PlayerRolesViewScreen.PlayerRolesViewScreen(data: data),
  validator: (data) {},
);

final secretRolesViewStep = ScenarioStep(
  title: 'Ознакомление ведущим',
  description: 'Ведущий ознакамливается с ролями игроков',
  contentBuilder: (data) => SecretRolesViewScreen(data: data),
  validator: (data) {},
);

final roleAssignmentStep = ScenarioStep(
  title: 'Распределение уже назначенных ролей',
  description: 'Укажите роли игроков',
  contentBuilder: (data) => RoleAssignmentScreen(data: data),
  validator: (data) {
    final int masterId = data['master'] ?? 0;
    final List<dynamic> playesrWithoutRole = data['gamers']
        .where((player) => player['team'] == null && player['id'] != masterId)
        .toList();
    if (playesrWithoutRole.isNotEmpty) {
      throw Exception('Нужно закрепить роли за всеми игроками');
    }

    data['teamsData'] = {};
    for (final Map<String, dynamic> playerData in data['gamers']) {
      if (playerData['team'] != null &&
          data['teamsData'][playerData['team'].toString()] == null) {
        setIniialTeamData(data['teamsData'], playerData['team']);
        data['teamsData'][playerData['team'].toString()]['name'] =
            playerData['role']['teamName'];
      }
    }
    data['numberTeams'] = data['teamsData'].length;
  },
);

final finalStep = ScenarioStep(
  title: 'Комментарий',
  description: 'Можете добавить кооментарий к партии',
  contentBuilder: (data) => FinalScreen(data: data),
  validator: (data) {},
);
