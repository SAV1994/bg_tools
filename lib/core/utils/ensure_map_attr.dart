void increaseEnsureCounter(Map data, dynamic attr, int value) {
  if (data[attr] != null) {
    data[attr] += value;
  } else {
    data[attr] = value;
  }
}

void addIntToEnsureList(Map data, dynamic attr, int value) {
  if (data[attr] != null) {
    data[attr].add(value);
  } else {
    data[attr] = [value];
  }
}
