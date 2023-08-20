import 'package:bsuir_schedule/data/api/current_week_api.dart';
import 'package:bsuir_schedule/data/shared_preferences/current_week_shared_prefs.dart';

class CurrentWeekService {
  static final CurrentWeekApi _currentWeekApi = CurrentWeekApi();
  static final CurrentWeekSharedPrefs _currentWeekSharedPrefs =
      CurrentWeekSharedPrefs();

  Future<int?> getCurrentWeek() async {
    final currentWeekApi = await _currentWeekApi.getCurrentWeek();

    if (currentWeekApi == null) {
      final currentWeekSharedPrefs =
          await _currentWeekSharedPrefs.getCurrentWeek();
      final currentWeek = currentWeekSharedPrefs.key;
      final currentWeekSetDate = currentWeekSharedPrefs.value;
      final weeksDelta =
          DateTime.now().difference(currentWeekSetDate).inDays ~/ 7;
      final actualWeek = (currentWeek + weeksDelta - 1) % 4 + 1;
      await _currentWeekSharedPrefs.setCurrentWeek(actualWeek);
      return actualWeek;
    }

    return currentWeekApi;
  }
}
