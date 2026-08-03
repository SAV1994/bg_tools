void increaseEnsureCounter(Map data, dynamic attr, int value) {
  if (data[attr] != null) {
    data[attr] += value;
  } else {
    data[attr] = value;
  }
}

void addToEnsureList(Map data, dynamic attr, dynamic value) {
  if (data[attr] != null) {
    data[attr].add(value);
  } else {
    data[attr] = [value];
  }
}
