// Тип рандомных списков
enum RandomListTypeEnum {
  setup(1, 'Сетап'),
  list(2, 'Простой список');

  final int id;
  final String label;

  const RandomListTypeEnum(this.id, this.label);

  // Получить enum по id
  static RandomListTypeEnum fromId(int id) {
    return RandomListTypeEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => RandomListTypeEnum.list,
    );
  }

  // Получить enum по названию
  static RandomListTypeEnum fromLabel(String label) {
    return RandomListTypeEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => RandomListTypeEnum.list,
    );
  }
}
