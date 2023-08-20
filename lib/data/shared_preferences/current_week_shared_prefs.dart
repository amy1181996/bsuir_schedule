import 'package:shared_preferences/shared_preferences.dart';

class CurrentWeekSharedPrefs {
  Future<void> setCurrentWeek(int week) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_week', week);
    await prefs.setString(
        'current_week_set_date', DateTime.now().toIso8601String());
  }

  Future<MapEntry<int, DateTime>> getCurrentWeek() async {
    final prefs = await SharedPreferences.getInstance();
    final week = prefs.getInt('current_week');
    final date = prefs.getString('current_week_set_date');
    if (week == null || date == null) {
      return MapEntry(1, DateTime.now());
    }
    return MapEntry(week, DateTime.parse(date));
  }
}
