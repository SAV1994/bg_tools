// 1 Тип игры
enum GameTypeEnum {
  classic(1, 'Распределение по местам'),
  oneWinner(2, 'Один победитель'),
  team(3, 'Командная игра'),
  coop(4, 'Кооператив'),
  solo(5, 'Соло');

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
  circle(1, 'Игроки ходят по очереди'),
  realTime(2, 'Игра в реальном времени');

  final int id;
  final String label;

  const FirstPlayerStartTypeEnum(this.id, this.label);

  // Получить enum по id
  static FirstPlayerStartTypeEnum fromId(int id) {
    return FirstPlayerStartTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => FirstPlayerStartTypeEnum.circle,
    );
  }

  // Получить enum по названию
  static FirstPlayerStartTypeEnum fromLabel(String label) {
    return FirstPlayerStartTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerStartTypeEnum.circle,
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

// 4 Тип игровых очков (Что нужно для победы?)
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

// 5 Определение первого игрока между раундами
enum FirstPlayerRoundTypeEnum {
  circle(1, 'По часовой стрелке'),
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
      orElse: () => FirstPlayerRoundTypeEnum.circle,
    );
  }

  // Получить enum по названию
  static FirstPlayerRoundTypeEnum fromLabel(String label) {
    return FirstPlayerRoundTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerRoundTypeEnum.circle,
    );
  }
}
