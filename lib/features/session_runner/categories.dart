// 1 Тип игры
enum GameTypeEnum {
  classic(1, 'Распределение по местам'),
  oneWinner(2, 'Один победитель'),
  team(3, 'Командная игра (есть 2 место)'),
  coop(4, 'Кооператив'),
  solo(5, 'Соло'),
  teamOneWinner(6, 'Командная игра (1 победитель)'),
  secretRoles(7, 'Тайные роли');

  final int id;
  final String label;

  const GameTypeEnum(this.id, this.label);

  // Получить enum по id
  static GameTypeEnum fromId(int id) {
    return GameTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => GameTypeEnum.classic,
    );
  }

  // Получить enum по названию
  static GameTypeEnum fromLabel(String label) {
    return GameTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => GameTypeEnum.classic,
    );
  }
}

// 2 Определение первого игрока в начале игры
enum FirstPlayerStartTypeEnum {
  queue(1, 'Игроки ходят по очереди'),
  sameTime(2, 'Порядок хода не важен');

  final int id;
  final String label;

  const FirstPlayerStartTypeEnum(this.id, this.label);

  // Получить enum по id
  static FirstPlayerStartTypeEnum fromId(int id) {
    return FirstPlayerStartTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => FirstPlayerStartTypeEnum.queue,
    );
  }

  // Получить enum по названию
  static FirstPlayerStartTypeEnum fromLabel(String label) {
    return FirstPlayerStartTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerStartTypeEnum.queue,
    );
  }
}

// 3 Тип процесса определения результативности
enum ResultTypeEnum {
  end(1, 'Подсчёт в конце игры'),
  round(2, 'Подсчёт между раундами'),
  condition(3, 'В игре нет подсчёта очков');

  final int id;
  final String label;

  const ResultTypeEnum(this.id, this.label);

  // Получить enum по id
  static ResultTypeEnum fromId(int id) {
    return ResultTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ResultTypeEnum.end,
    );
  }

  // Получить enum по названию
  static ResultTypeEnum fromLabel(String label) {
    return ResultTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => ResultTypeEnum.end,
    );
  }
}

// 4 Тип игровых очков при командной игре
enum TeamPointTypeEnum {
  personal(1, 'Личные очков'),
  general(2, 'Общие очков');

  final int id;
  final String label;

  const TeamPointTypeEnum(this.id, this.label);

  // Получить enum по id
  static TeamPointTypeEnum fromId(int id) {
    return TeamPointTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => TeamPointTypeEnum.personal,
    );
  }

  // Получить enum по названию
  static TeamPointTypeEnum fromLabel(String label) {
    return TeamPointTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => TeamPointTypeEnum.personal,
    );
  }
}

// 5 Тип игровых очков (Что нужно для победы?)
enum PointTypeEnum {
  max(1, 'Максимум очков'),
  min(2, 'Минимум очков');

  final int id;
  final String label;

  const PointTypeEnum(this.id, this.label);

  // Получить enum по id
  static PointTypeEnum fromId(int id) {
    return PointTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => PointTypeEnum.max,
    );
  }

  // Получить enum по названию
  static PointTypeEnum fromLabel(String label) {
    return PointTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => PointTypeEnum.max,
    );
  }
}

// 6 Тип раундов
enum RoundsTypeEnum {
  fix(1, 'Фиксированное количество раундов'),
  dynamic(2, 'Произвольное количество раундов'),
  condition(3, 'По достижению лимита очков');

  final int id;
  final String label;

  const RoundsTypeEnum(this.id, this.label);

  // Получить enum по id
  static RoundsTypeEnum fromId(int id) {
    return RoundsTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => RoundsTypeEnum.fix,
    );
  }

  // Получить enum по названию
  static RoundsTypeEnum fromLabel(String label) {
    return RoundsTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => RoundsTypeEnum.fix,
    );
  }
}

// 7 Алтернативные условия победы
enum AltVictoryTypeEnum {
  yes(1, 'есть'),
  no(2, 'нет');

  final int id;
  final String label;

  const AltVictoryTypeEnum(this.id, this.label);

  // Получить enum по id
  static AltVictoryTypeEnum fromId(int id) {
    return AltVictoryTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => AltVictoryTypeEnum.no,
    );
  }

  // Получить enum по названию
  static AltVictoryTypeEnum fromLabel(String label) {
    return AltVictoryTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => AltVictoryTypeEnum.no,
    );
  }
}

// 8 Определение первого игрока между раундами
enum FirstPlayerRoundTypeEnum {
  queue(1, 'Следующий по часовой стрелке'),
  leader(2, 'Победитель ходит первым'),
  loser(3, 'Проигравший ходит первым'),
  leaderNext(4, 'Cледующий за победителем'),
  manually(5, 'Будет задаваться вручную');

  final int id;
  final String label;

  const FirstPlayerRoundTypeEnum(this.id, this.label);

  // Получить enum по id
  static FirstPlayerRoundTypeEnum fromId(int id) {
    return FirstPlayerRoundTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => FirstPlayerRoundTypeEnum.queue,
    );
  }

  // Получить enum по названию
  static FirstPlayerRoundTypeEnum fromLabel(String label) {
    return FirstPlayerRoundTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerRoundTypeEnum.queue,
    );
  }
}

// 9 Тип последовательности ходов игроков
enum SequencePlayersMovesTypeEnum {
  clockwise(1, 'По часовой стрелке'),
  random(2, 'Вразнобой');

  final int id;
  final String label;

  const SequencePlayersMovesTypeEnum(this.id, this.label);

  // Получить enum по id
  static SequencePlayersMovesTypeEnum fromId(int id) {
    return SequencePlayersMovesTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => SequencePlayersMovesTypeEnum.clockwise,
    );
  }

  // Получить enum по названию
  static FirstPlayerRoundTypeEnum fromLabel(String label) {
    return FirstPlayerRoundTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerRoundTypeEnum.queue,
    );
  }
}
