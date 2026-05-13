// Вид игры
enum GameTypeEnum {
  coop('Кооператив (соло)'),
  team('Командная игра'),
  classic('Один победитель');

  final String label;

  const GameTypeEnum(this.label);

  static GameTypeEnum fromString(String value) {
    return GameTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GameTypeEnum.classic,
    );
  }
}

// Определение первого игрока в первом раунде
enum FirstPlayerStartTypeEnum {
  circle('Игроки ходят по кругу'),
  random('Игроки ходят в произвольном порядке');

  final String label;

  const FirstPlayerStartTypeEnum(this.label);

  static FirstPlayerStartTypeEnum fromString(String value) {
    return FirstPlayerStartTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FirstPlayerStartTypeEnum.circle,
    );
  }
}

// Определение первого игрока между раундами
enum FirstPlayerRoundTypeEnum {
  circle('По часовой стрелке от текущего первого игрока'),
  leader('Победитель ходит первым'),
  loser('Проигравший ходит первым'),
  leaderNext('Ходит следующий игрок за победителем'),
  manually('Будет задаваться вручную');

  final String label;

  const FirstPlayerRoundTypeEnum(this.label);

  static FirstPlayerRoundTypeEnum fromString(String value) {
    return FirstPlayerRoundTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FirstPlayerRoundTypeEnum.circle,
    );
  }
}

// Тип процесса определения результативности
enum ResultTypeEnum {
  end('Подсчёт в конце игры'),
  round('Подсчёт между раундами'),
  condition('В игре нет подсчёта очков');

  final String label;

  const ResultTypeEnum(this.label);

  static ResultTypeEnum fromString(String value) {
    return ResultTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ResultTypeEnum.end,
    );
  }
}

// Тип игровых очков (Что нужно для победы?)
enum PointTypeEnum {
  max('Максимум очков'),
  min('Минимум очков');

  final String label;

  const PointTypeEnum(this.label);

  static PointTypeEnum fromString(String value) {
    return PointTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PointTypeEnum.max,
    );
  }
}
