class CurrentWeekService {
  int getCurrentWeek() {
    return getWeekNumberFor(DateTime.now());
  }

  int getWeekNumberFor(DateTime now) {
    final initialDate = DateTime(now.year, 9, 1);

    int difference = now.difference(initialDate).inDays;

    final int daysUntilMonday = (8 - initialDate.weekday) % 7;

    if (difference < daysUntilMonday) {
      return 1;
    }

    difference -= daysUntilMonday;
    final currentWeek = (difference ~/ 7 + 1) % 4 + 1;
    return currentWeek;
  }
}
