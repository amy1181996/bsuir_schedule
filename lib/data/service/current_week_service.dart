import 'package:bsuir_schedule/data/api/current_week_api.dart';
import 'package:bsuir_schedule/data/shared_preferences/current_week_shared_prefs.dart';

class CurrentWeekService {
  static final CurrentWeekApi _currentWeekApi = CurrentWeekApi();
  static final CurrentWeekSharedPrefs _currentWeekSharedPrefs =
      CurrentWeekSharedPrefs();

  Future<int?> getCurrentWeek() async {
    final currentWeekSharedPrefs =
        await _currentWeekSharedPrefs.getCurrentWeek();
    int? currentWeek = currentWeekSharedPrefs.key;
    final currentWeekSetDate = currentWeekSharedPrefs.value;

    if (currentWeek == null) {
      currentWeek = await _currentWeekApi.getCurrentWeek() ?? 1;
      final weeksDelta =
          DateTime.now().difference(currentWeekSetDate).inDays ~/ 7;
      currentWeek = (currentWeek + weeksDelta - 1) % 4 + 1;
      await _currentWeekSharedPrefs.setCurrentWeek(currentWeek);
    }

    return currentWeek;
  }
}
