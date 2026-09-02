double average(List<int> numbers) {
  if (numbers.isEmpty) return 0.0;
  return numbers.fold(0, (sum, item) => sum + item) / numbers.length;
}

int sumInt(List<int> numbers) {
  return numbers.fold(0, (sum, item) => sum + item);
}

double sumDouble(List<double> numbers) {
  return numbers.fold(0.0, (sum, item) => sum + item);
}
