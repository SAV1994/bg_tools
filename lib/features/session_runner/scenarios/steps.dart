import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';
import 'package:bg_tools/features/session_runner/screens/export.dart';

final rootSessionSelectStep = ScenarioStep(
  title: 'Первая сессия',
  description:
      'Вы можете выбрать записанную ранее сессию для сохранения связи между серией игровых сессий. Может быть актуально для игр-компаний. Выбирайте имеено первую сессию серии.',
  contentBuilder: (data) => RootSessionSelectScreen(data: data),
  validator: (data) {},
);

final numberRoundsStep = ScenarioStep(
  title: 'Количество раундов',
  description: 'Укажите количество раундов',
  contentBuilder: (data) => NumberRoundsScreen(data: data),
  validator: (data) {
    if (data['totalRounds'] == null || data['totalRounds'] < 1) {
      throw Exception('Укажите количкство раундов');
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
    final List<dynamic> gamersData = [];
    for (final Map<String, dynamic> gamerData in data['gamers']) {
      gamersData.add({
        'id': gamerData['id'],
        'username': gamerData['username'],
        'fio': gamerData['fio'],
        'score': null,
        'scoreByrounds': [],
        'place': null,
        'turnOrder': null,
        'team': null,
      });
    }
    AppDataManager.saveLastSessionGamers(gamersData);
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
    if (data['round'] != data['totalRounds']) {
      throw Exception('Нужно завершить все раунды');
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

final scoreInputStep = ScenarioStep(
  title: 'Ввод результатов партии',
  description: 'Отметьте результаты партии',
  contentBuilder: (data) => ScoreInputScreen(data: data),
  validator: (data) {
    for (final Map<String, dynamic> gamerData in data['gamers']) {
      if (gamerData['score'] == null) {
        throw Exception('Отметьте результаты каждого игрока');
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

final finalStep = ScenarioStep(
  title: 'Комментарий',
  description: 'Можете добавить кооментарий к партии',
  contentBuilder: (data) => FinalScreen(data: data),
  validator: (data) {},
);
