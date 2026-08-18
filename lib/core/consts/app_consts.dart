import 'dart:math';

// Название Приложения
const String appName = '🎲 BGTools';

// Условное число обозначающее неограниченное количество раундов
const int infNumRounds = 999999;

// Затычка на случай, если поле пустое
const String emptyVal = '—';

// Варианты строк для виджета загрузки
String getLoadingMsg() {
  const List<String> loadingMsgs = [
    'Кидаем кубы...',
    'Изучаем карты...',
    'Даунтайм...',
    'Паралич анализа. Ждите...',
  ];
  return loadingMsgs[Random().nextInt(loadingMsgs.length)];
}

// Месяцы
enum MonthsEnum {
  january(1, 'Январь'),
  february(2, 'Февраль'),
  march(3, 'Март'),
  april(4, 'Апрель'),
  may(5, 'Май'),
  june(6, 'Июнь'),
  july(7, 'Июль'),
  august(8, 'Август'),
  september(9, 'Сентябрь'),
  october(10, 'Октябрь'),
  november(11, 'Ноябрь'),
  december(12, 'Декабрь');

  final int id;
  final String label;

  const MonthsEnum(this.id, this.label);

  // Получить enum по id
  static MonthsEnum fromId(int id) {
    return MonthsEnum.values.firstWhere(
      (e) => e.id == id,
      orElse: () => MonthsEnum.january,
    );
  }
}

// Пагинация
const int pageSize = 25;
