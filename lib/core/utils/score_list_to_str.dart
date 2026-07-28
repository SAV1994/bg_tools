String convertScoreListToStr(List scores) {
  return scores.map((score) => score.toString()).join(' | ');
}
