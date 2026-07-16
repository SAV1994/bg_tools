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

// Пагинация
const int pageSize = 25;
