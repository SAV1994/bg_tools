// Вид игры
enum GameType {
  coop('Кооператив (соло)'),
  team('Командная игра'),
  classic('Один победитель');

  final String label;

  const GameType(this.label);

  static GameType fromString(String value) {
    return GameType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GameType.classic,
    );
  }
}

// Определение первого игрока в первом раунде
enum FirstPlayerStartType {
  circle('Игроки ходят по кругу'),
  random('Игроки ходят в произвольном порядке');

  final String label;

  const FirstPlayerStartType(this.label);

  static FirstPlayerStartType fromString(String value) {
    return FirstPlayerStartType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FirstPlayerStartType.circle,
    );
  }
}

// Определение первого игрока между раундами
enum FirstPlayerRoundType {
  circle('По часовой стрелке от текущего первого игрока'),
  leader('Победитель ходит первым'),
  loser('Проигравший ходит первым'),
  leaderNext('Ходит следующий игрок за победителем'),
  manually('Будет задаваться вручную');

  final String label;

  const FirstPlayerRoundType(this.label);

  static FirstPlayerRoundType fromString(String value) {
    return FirstPlayerRoundType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FirstPlayerRoundType.circle,
    );
  }
}

// Тип процесса определения результативности
enum ResultType {
  end('Подсчёт в конце игры'),
  round('Подсчёт между раундами'),
  condition('В игре нет подсчёта очков');

  final String label;

  const ResultType(this.label);

  static ResultType fromString(String value) {
    return ResultType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ResultType.end,
    );
  }
}

// Тип игровых очков (Что нужно для победы?)
enum PointType {
  max('Максимум очков'),
  min('Минимум очков');

  final String label;

  const PointType(this.label);

  static PointType fromString(String value) {
    return PointType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PointType.max,
    );
  }
}
