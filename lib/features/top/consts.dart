import 'package:bg_tools/core/database/app_database.dart';

enum TopTypeEnum {
  common(1, 'Общий', null),
  byTag(2, 'Игры по тэгу', Tag),
  byDesigner(3, 'Игры геймдизайнера', Designer),
  byArtist(4, 'Игры художника', Artist);

  final int id;
  final String label;
  final Type? model;

  const TopTypeEnum(this.id, this.label, this.model);

  // Получить enum по id
  static TopTypeEnum fromId(int id) {
    return TopTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => TopTypeEnum.common,
    );
  }
}
