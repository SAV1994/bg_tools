String formatMinutes(int totalMinutes) {
  final hours = totalMinutes ~/ 60; // Целое количество часов
  final minutes = totalMinutes % 60; // Остаток минут
  if (hours > 0) {
    return '$hours ч $minutes мин';
  } else {
    return '$minutes мин';
  }
}
