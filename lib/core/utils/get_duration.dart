Object getDuration(
  DateTime dateTime,
  DateTime secondDateTime, {
  bool convertToStr = true,
}) {
  final Duration duration;

  if (dateTime.isBefore(secondDateTime)) {
    duration = secondDateTime.difference(dateTime);
  } else {
    duration = dateTime.difference(secondDateTime!);
  }

  if (convertToStr) {
    return convertDurationToStr(duration);
  }

  return duration;
}

String convertDurationToStr(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours == 0) {
    return '$minutes мин.';
  }

  return '$hours ч. $minutes мин.';
}

Object getTotaDuration(
  List<Duration> durationList, {
  bool convertToStr = true,
}) {
  Duration totalDuration = Duration();

  for (Duration duration in durationList) {
    totalDuration += duration;
  }

  if (convertToStr) {
    return convertDurationToStr(totalDuration);
  }

  return totalDuration;
}
