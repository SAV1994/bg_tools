String getDuration(DateTime dateTime, DateTime secondDateTime) {
  final Duration difference;

  if (dateTime.isBefore(secondDateTime)) {
    difference = secondDateTime.difference(dateTime);
  } else {
    difference = dateTime.difference(secondDateTime!);
  }

  // Вычисляем общее количество часов и оставшиеся минуты
  final hours = difference.inHours;
  final minutes = difference.inMinutes.remainder(60);

  if (hours == 0) {
    return '$minutes мин.';
  }

  return '$hours ч. $minutes мин.';
}
