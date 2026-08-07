import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/utils/export.dart';

// 1 Тип игры
enum GameTypeEnum {
  classic(1, 'Распределение по местам'),
  oneWinner(2, 'Один победитель'),
  team(3, 'Командная игра (есть 2 место)'),
  coop(4, 'Кооператив'),
  solo(5, 'Соло'),
  teamOneWinner(6, 'Командная игра (1 победитель)'),
  secretRoles(7, 'Тайные роли'),
  secretTeams(8, 'Скрытые команды / С предателем');

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

  static List<SelectItem> getSelectItems() {
    return GameTypeEnum.values
        .map((item) => SelectItem(item.id, item.label))
        .toList();
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return GameTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип игры';
}

// 2 Тип определения первого игрока
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return FirstPlayerStartTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип определения первого игрока';
}

// 3 Тип определения результативности
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return ResultTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип определения результативности';
}

// 4 Возможность общего поражения
enum GeneralDefeatTypeEnum {
  yes(1, 'Да'),
  no(2, 'Нет');

  final int id;
  final String label;

  const GeneralDefeatTypeEnum(this.id, this.label);

  // Получить enum по id
  static GeneralDefeatTypeEnum fromId(int id) {
    return GeneralDefeatTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => GeneralDefeatTypeEnum.no,
    );
  }

  // Получить enum по названию
  static GeneralDefeatTypeEnum fromLabel(String label) {
    return GeneralDefeatTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => GeneralDefeatTypeEnum.no,
    );
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return GeneralDefeatTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Возможность общего поражения';
}

// 5 Тип игровых очков при командной игре
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return TeamPointTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип игровых очков при командной игре';
}

// 6 Тип игровых очков
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return PointTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип игровых очков';
}

// 7 Тип раундов
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return RoundsTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип раундов';
}

// 8 Алтернативные условия победы
enum AltVictoryTypeEnum {
  yes(1, 'Да'),
  no(2, 'Нет');

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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return AltVictoryTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Алтернативные условия победы';
}

// 9 Тип определения первого игрока в раунде
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return FirstPlayerRoundTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип определения первого игрока в раунде';
}

// 10 Тип очков для определения первого игрока
enum FirstPlayerRoundPointTypeEnum {
  total(1, 'Общее количество очков'),
  round(2, 'Количество очков за раунд');

  final int id;
  final String label;

  const FirstPlayerRoundPointTypeEnum(this.id, this.label);

  // Получить enum по id
  static FirstPlayerRoundPointTypeEnum fromId(int id) {
    return FirstPlayerRoundPointTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => FirstPlayerRoundPointTypeEnum.total,
    );
  }

  // Получить enum по названию
  static FirstPlayerRoundPointTypeEnum fromLabel(String label) {
    return FirstPlayerRoundPointTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => FirstPlayerRoundPointTypeEnum.total,
    );
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return FirstPlayerRoundPointTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип очков для определения первого игрока';
}

// 11 Тип последовательности ходов игроков
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

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return SequencePlayersMovesTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип последовательности ходов игроков';
}

// 12 Тип организации игры
enum GameHostTypeEnum {
  master(1, 'Есть ведущий'),
  noMaster(2, 'Без ведущего');

  final int id;
  final String label;

  const GameHostTypeEnum(this.id, this.label);

  // Получить enum по id
  static GameHostTypeEnum fromId(int id) {
    return GameHostTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => GameHostTypeEnum.noMaster,
    );
  }

  // Получить enum по названию
  static GameHostTypeEnum fromLabel(String label) {
    return GameHostTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => GameHostTypeEnum.noMaster,
    );
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return GameHostTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Тип организации игры';
}

// 13 Способ распределения ролей
enum SecretRolesDistributionTypeEnum {
  auto(1, 'Определяются приложением'),
  manually(2, 'Определяются вручную');

  final int id;
  final String label;

  const SecretRolesDistributionTypeEnum(this.id, this.label);

  // Получить enum по id
  static SecretRolesDistributionTypeEnum fromId(int id) {
    return SecretRolesDistributionTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => SecretRolesDistributionTypeEnum.auto,
    );
  }

  // Получить enum по названию
  static SecretRolesDistributionTypeEnum fromLabel(String label) {
    return SecretRolesDistributionTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => SecretRolesDistributionTypeEnum.auto,
    );
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return SecretRolesDistributionTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Способ распределения ролей';
}

// 14 Уникальность ролей
enum UniquenessRolesTypeEnum {
  unique(1, 'Уникальные'),
  repeat(2, 'Могут повторятся');

  final int id;
  final String label;

  const UniquenessRolesTypeEnum(this.id, this.label);

  // Получить enum по id
  static UniquenessRolesTypeEnum fromId(int id) {
    return UniquenessRolesTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => UniquenessRolesTypeEnum.repeat,
    );
  }

  // Получить enum по названию
  static UniquenessRolesTypeEnum fromLabel(String label) {
    return UniquenessRolesTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => UniquenessRolesTypeEnum.repeat,
    );
  }

  static Iterable<DropdownMenuItem<Enum>> getDropdownMenuItems() {
    return UniquenessRolesTypeEnum.values.map((val) {
      return DropdownMenuItem(
        value: val,
        child: Row(
          children: [Text(val.label, style: TextStyle(color: textColor))],
        ),
      );
    });
  }

  static String get title => 'Уникальность ролей';
}
