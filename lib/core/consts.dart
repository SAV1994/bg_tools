// Название Приложения
import 'dart:math';

const String appName = 'BGTools';
// Затычка на случай, если записей нет
const String emptyListMsg = 'Пусто ¯\\_(ツ)_/¯';
// Затычка на случай, если поле пустое
const String emptyVal = '—';
// Варианты строк для виджета загрузки
String getLoadingMsg() {
  const List<String> loadingMsgs = [
    'Кидаем кубы...',
    'Изучаем карты...',
    'Даунтайм...',
  ];
  return loadingMsgs[Random().nextInt(loadingMsgs.length)];
}
