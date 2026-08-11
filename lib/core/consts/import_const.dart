enum ImportTypeEnum {
  all(1, 'Все данные'),
  game(2, 'Одна игра'),
  template(3, 'Один шаблон');

  final int id;
  final String title;

  const ImportTypeEnum(this.id, this.title);
}

const String importDataVersionCodeKey = 'versionCode';
const String importDataVersionCode = 'BgTools@1';
